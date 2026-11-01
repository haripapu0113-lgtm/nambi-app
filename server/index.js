const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const rateLimit = require("express-rate-limit");

const app = express();

const PORT = process.env.PORT || 3000;

const OLLAMA_URL =
  process.env.OLLAMA_URL || "http://127.0.0.1:11434";

const MODEL =
  process.env.NAMBI_MODEL || "qwen2.5:1.5b";

const ALLOWED_ORIGIN =
  process.env.ALLOWED_ORIGIN || "http://localhost:5500";

app.use(helmet());

app.use(cors({
  origin: ALLOWED_ORIGIN
}));

app.use(express.json({ limit: "1mb" }));

app.use("/api/", rateLimit({
  windowMs: 60 * 1000,
  limit: 20
}));

app.get("/", (req, res) => {
  res.json({
    name: "NAMBI AI",
    message: "Welcome to NAMBI AI Server"
  });
});

app.get("/api/health", (req, res) => {
  res.json({
    name: "NAMBI AI",
    status: "online",
    model: MODEL
  });
});

app.post("/api/chat", async (req, res) => {
  try {
    const message = req.body.message;

    if (
      typeof message !== "string" ||
      !message.trim() ||
      message.length > 10000
    ) {
      return res.status(400).json({
        error: "Please enter a valid message"
      });
    }

    const history = Array.isArray(req.body.history)
      ? req.body.history.slice(-10)
      : [];

    const messages = [
      {
        role: "system",
        content: `
You are NAMBI, an independent AI assistant.

Your identity is NAMBI.
Never claim to be Gemini or ChatGPT.

You must:
- Understand Tamil, English and Tanglish.
- Reply in the user's preferred language.
- Explain clearly step by step.
- Help with education, work, coding and business.
- Be honest about your limitations.
- Never invent information.
- Respect user privacy.

You are an early version of NAMBI AI.
        `.trim()
      },

      ...history.filter(item =>
        item &&
        ["user", "assistant"].includes(item.role) &&
        typeof item.content === "string"
      ),

      {
        role: "user",
        content: message.trim()
      }
    ];

    const response = await fetch(
      `${OLLAMA_URL}/api/chat`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          model: MODEL,
          messages,
          stream: false
        }),
        signal: AbortSignal.timeout(120000)
      }
    );

    if (!response.ok) {
      throw new Error("AI model server unavailable");
    }

    const data = await response.json();

    const reply = data.message?.content;

    if (!reply) {
      throw new Error("Empty AI response");
    }

    res.json({
      brand: "NAMBI",
      reply: reply,
      model: MODEL
    });

  } catch (error) {
    console.error("NAMBI error:", error.message);

    res.status(503).json({
      error: "NAMBI AI is temporarily unavailable"
    });
  }
});

app.listen(PORT, "0.0.0.0", () => {
  console.log("NAMBI AI server running on port " + PORT);
});
