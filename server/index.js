
const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const rateLimit = require("express-rate-limit");

const app = express();

const PORT = process.env.PORT || 3000;
const OLLAMA_URL = (
  process.env.OLLAMA_URL || "http://127.0.0.1:11434"
).replace(/\/+$/, "");

const MODEL = process.env.NAMBI_MODEL || "qwen2.5:1.5b";

const ALLOWED_ORIGINS = (
  process.env.ALLOWED_ORIGINS ||
  "https://haripapu0113-lgtm.github.io"
)
  .split(",")
  .map(origin => origin.trim())
  .filter(Boolean);

app.disable("x-powered-by");

app.use(helmet());

app.use(cors({
  origin: (origin, callback) => {
    if (!origin || ALLOWED_ORIGINS.includes(origin)) {
      return callback(null, true);
    }
    return callback(new Error("CORS origin not allowed"));
  },
  methods: ["GET", "POST"],
  allowedHeaders: ["Content-Type"]
}));

app.use(express.json({ limit: "1mb" }));

app.use("/api/", rateLimit({
  windowMs: 60 * 1000,
  limit: 20,
  standardHeaders: true,
  legacyHeaders: false
}));

app.get("/", (req, res) => {
  res.json({
    name: "NAMBI AI",
    message: "NAMBI backend is running"
  });
});

// Check backend and Ollama model availability
app.get("/api/health", async (req, res) => {
  try {
    const response = await fetch(`${OLLAMA_URL}/api/tags`, {
      signal: AbortSignal.timeout(10000)
    });

    if (!response.ok) {
      throw new Error("Ollama unavailable");
    }

    const data = await response.json();

    const modelAvailable = (data.models || []).some(
      item => item.name === MODEL
    );

    if (!modelAvailable) {
      return res.status(503).json({
        name: "NAMBI AI",
        status: "model_not_ready"
      });
    }

    return res.json({
      name: "NAMBI AI",
      status: "online",
      model: MODEL
    });

  } catch {
    return res.status(503).json({
      name: "NAMBI AI",
      status: "temporarily_unavailable"
    });
  }
});

// AI chat endpoint
app.post("/api/chat", async (req, res) => {
  try {
    const { message, history = [] } = req.body || {};

    if (
      typeof message !== "string" ||
      !message.trim() ||
      message.length > 10000
    ) {
      return res.status(400).json({
        error: "Please enter a valid message"
      });
    }

    if (!Array.isArray(history) || history.length > 50) {
      return res.status(400).json({
        error: "Invalid chat history"
      });
    }

    const recentHistory = history.slice(-10);

    const cleanHistory = [];

    for (const item of recentHistory) {
      if (
        !item ||
        !["user", "assistant"].includes(item.role) ||
        typeof item.content !== "string" ||
        item.content.length > 4000
      ) {
        return res.status(400).json({
          error: "Invalid chat history item"
        });
      }

      cleanHistory.push({
        role: item.role,
        content: item.content
      });
    }

    const totalHistoryLength = cleanHistory.reduce(
      (total, item) => total + item.content.length,
      0
    );

    if (totalHistoryLength > 20000) {
      return res.status(400).json({
        error: "Chat history is too large"
      });
    }

    const messages = [
      {
        role: "system",
        content: `
You are NAMBI, an independent AI assistant.

Your identity is NAMBI.
Never claim to be ChatGPT or Gemini.

Instructions:
- Understand Tamil, English and Tanglish.
- Reply in the user's language.
- Explain clearly and step by step.
- Help with education, work, coding and business.
- Be honest about limitations.
- Never invent facts.
- Respect user privacy.
- Do not claim that you have stored or deleted data unless verified.
        `.trim()
      },
      ...cleanHistory,
      {
        role: "user",
        content: message.trim()
      }
    ];

    const response = await fetch(`${OLLAMA_URL}/api/chat`, {
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
    });

    if (!response.ok) {
      throw new Error("AI model request failed");
    }

    const data = await response.json();
    const reply = data.message?.content;

    if (!reply) {
      throw new Error("Empty AI response");
    }

    return res.json({
      brand: "NAMBI",
      reply,
      model: MODEL
    });

  } catch {
    // Never log customer messages or chat history.
    console.error("NAMBI AI request failed");

    return res.status(503).json({
      error: "NAMBI AI is temporarily unavailable"
    });
  }
});

// General error handler
app.use((err, req, res, next) => {
  if (res.headersSent) {
    return next(err);
  }

  if (err.type === "entity.parse.failed") {
    return res.status(400).json({
      error: "Invalid JSON request"
    });
  }

  if (err.message === "CORS origin not allowed") {
    return res.status(403).json({
      error: "Origin not allowed"
    });
  }

  console.error("NAMBI server error");

  return res.status(500).json({
    error: "Internal server error"
  });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`NAMBI AI server running on port ${PORT}`);
});
