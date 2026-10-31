
import 'package:flutter/material.dart';

void main() {
  runApp(const NambiApp());
}

const Color gold = Color(0xFFD6B45C);
const Color black = Color(0xFF101010);
const Color panel = Color(0xFF202020);

class NambiApp extends StatelessWidget {
  const NambiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NAMBI AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: black,
        colorScheme: const ColorScheme.dark(
          primary: gold,
          secondary: gold,
          surface: panel,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: black,
          foregroundColor: gold,
          elevation: 0,
        ),
      ),
      home: const NambiHome(),
    );
  }
}

class NambiHome extends StatefulWidget {
  const NambiHome({super.key});

  @override
  State<NambiHome> createState() => _NambiHomeState();
}

class _NambiHomeState extends State<NambiHome> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    ChatPage(),
    AssessmentPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.workspace_premium, size: 30),
            SizedBox(width: 10),
            Text(
              'NAMBI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                fontSize: 23,
              ),
            ),
            SizedBox(width: 6),
            Text(
              'AI',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Icon(Icons.shield_outlined),
          ),
        ],
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: panel,
        indicatorColor: gold.withOpacity(0.18),
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: gold),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat, color: gold),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology, color: gold),
            label: 'Assess',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: gold),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// HOME SCREEN

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 12),

        const Text(
          'Hello! Welcome to NAMBI.',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Your Intelligence. Your Privacy.',
          style: TextStyle(color: gold, fontSize: 15),
        ),

        const SizedBox(height: 28),

        const ChatInput(),

        const SizedBox(height: 30),

        const Text(
          'Explore NAMBI',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: const [
            FeatureCard(
              title: 'NAMBI Chat',
              description: 'Ask anything',
              icon: Icons.chat_bubble_outline,
            ),
            FeatureCard(
              title: 'NAMBI Work',
              description: 'Office assistant',
              icon: Icons.work_outline,
            ),
            FeatureCard(
              title: 'NAMBI Assess',
              description: 'Tests and practice',
              icon: Icons.psychology_outlined,
            ),
            FeatureCard(
              title: 'NAMBI Learn',
              description: 'Learn anything',
              icon: Icons.school_outlined,
            ),
            FeatureCard(
              title: 'NAMBI Career',
              description: 'Jobs and interviews',
              icon: Icons.business_center_outlined,
            ),
            FeatureCard(
              title: 'NAMBI Business',
              description: 'Business assistant',
              icon: Icons.store_outlined,
            ),
          ],
        ),

        const SizedBox(height: 28),

        const Center(
          child: Text(
            'POWERED BY NAMBI TECHNOLOGIES',
            style: TextStyle(
              color: gold,
              fontSize: 11,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }
}

// CHAT INPUT

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gold.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: gold),
              SizedBox(width: 10),
              Text(
                'Ask NAMBI anything',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TextField(
            controller: controller,
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Ask in Tamil or English...',
              filled: true,
              fillColor: black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_upward, color: gold),
                onPressed: () {
                  if (controller.text.trim().isEmpty) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        initialMessage: controller.text.trim(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// FEATURE CARDS

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FeaturePage(title: title),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: panel,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: gold.withOpacity(0.35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: gold, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CHAT PAGE - LOCAL UI PROTOTYPE

class ChatPage extends StatefulWidget {
  final String? initialMessage;

  const ChatPage({super.key, this.initialMessage});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();
  final List<String> messages = [];

  @override
  void initState() {
    super.initState();

    if (widget.initialMessage != null) {
      messages.add(widget.initialMessage!);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void sendMessage() {
    final value = controller.text.trim();
    if (value.isEmpty) return;

    setState(() {
      messages.add(value);
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NAMBI Chat')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Hello! I am NAMBI. How can I help you?',
              style: TextStyle(color: gold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: panel,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(messages[index]),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              onSubmitted: (_) => sendMessage(),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                suffixIcon: IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send, color: gold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ASSESSMENT PAGE

class AssessmentPage extends StatelessWidget {
  const AssessmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tests = [
      'Aptitude Practice',
      'Logical Reasoning',
      'Numerical Ability',
      'English Assessment',
      'Interview Preparation',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('NAMBI Assess')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Improve your skills with practice.',
            style: TextStyle(color: gold, fontSize: 17),
          ),
          const SizedBox(height: 18),
          ...tests.map(
            (test) => Card(
              color: panel,
              child: ListTile(
                leading: const Icon(
                  Icons.quiz_outlined,
                  color: gold,
                ),
                title: Text(test),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FeaturePage(title: test),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SETTINGS

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Text(
          'NAMBI Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        ListTile(
          leading: Icon(Icons.language, color: gold),
          title: Text('Language'),
          subtitle: Text('Tamil / English'),
        ),
        ListTile(
          leading: Icon(Icons.lock_outline, color: gold),
          title: Text('Privacy'),
          subtitle: Text('Privacy controls and data settings'),
        ),
        ListTile(
          leading: Icon(Icons.info_outline, color: gold),
          title: Text('About NAMBI'),
          subtitle: Text('Your Intelligence. Your Privacy.'),
        ),
      ],
    );
  }
}

// FEATURE PLACEHOLDER

class FeaturePage extends StatelessWidget {
  final String title;

  const FeaturePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome,
                color: gold,
                size: 60,
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'This NAMBI feature is under development.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
