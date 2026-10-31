import 'package:flutter/material.dart';

void main() { runApp(NAMBIApp()); }

class NAMBIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NAMBI',
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF6C4DFF))),
      home: NambiHome(),
    );
  }
}

class NambiHome extends StatefulWidget {
  @override
  State<NambiHome> createState() => _NambiHomeState();
}

class _NambiHomeState extends State<NambiHome> {
  int _index = 0;

  final _pages = [SecureSharePage(), VoiceVaultPage(), CreativeStudioPage(), CaringSpacePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NAMBI 💜', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFF6C4DFF),
        foregroundColor: Colors.white,
      ),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(icon: Icon(Icons.shield_rounded), label: 'Secure Share'),
          NavigationDestination(icon: Icon(Icons.mic_rounded), label: 'Voice Vault'),
          NavigationDestination(icon: Icon(Icons.palette_rounded), label: 'Creative'),
          NavigationDestination(icon: Icon(Icons.favorite_rounded), label: 'Caring'),
        ],
      ),
    );
  }
}

// 1. SECURE DATA SHARING - Unique Feature
class SecureSharePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _featureCard('🔒 End-to-End Encrypted Share', 'Your files never touch our server. Direct P2P with auto-burn after 1 view.', Colors.deepPurple),
        _featureCard('⏳ Self-Destruct Link', 'Link expires in 10 min / 1 view / 1 day - you control. No trace left.', Colors.indigo),
        _featureCard('👁️ No Screenshot Mode', 'Receiver cannot screenshot or screen record - private viewing only.', Colors.purple),
        _featureCard('🕵️ Ghost Mode', 'Share without showing your number/name. 100% anonymous but trusted.', Colors.deepPurpleAccent),
        SizedBox(height: 20),
        ElevatedButton.icon(
          icon: Icon(Icons.send_rounded),
          label: Text('Create Secure Link'),
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6C4DFF), foregroundColor: Colors.white, minimumSize: Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('NAMBI Secure Link Created! 🔗'))),
        ),
      ],
    );
  }
}

// 2. VOICE VAULT - Unique Feature
class VoiceVaultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _featureCard('🎙️ Emotion Voice', 'Voice changes to happy/sad/caring automatically based on your feeling - AI detects.', Colors.orange),
        _featureCard('🔐 Voice Lock', 'Only your voice can open this message. Voiceprint authentication.', Colors.deepOrange),
        _featureCard('💌 Voice Hug', 'Send a voice that feels like a hug - with heartbeat vibration on receiver phone.', Colors.pink),
        _featureCard('⏪ Unsend Voice', 'Delete voice even after heard. NAMBI recalls it from their phone.', Colors.redAccent),
        SizedBox(height: 80),
        Center(child: Column(children: [
          Container(padding: EdgeInsets.all(20), decoration: BoxDecoration(color: Color(0xFF6C4DFF).withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.mic, size: 60, color: Color(0xFF6C4DFF))),
          SizedBox(height: 16),
          Text('Hold to Record Caring Voice', style: TextStyle(fontWeight: FontWeight.bold)),
        ])),
      ],
    );
  }
}

// 3. CREATIVE IMAGES - Unique Feature
class CreativeStudioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(16),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _creativeTile('Mood Filter', 'Photo mood auto changes to receiver mood', '🎨'),
        _creativeTile('Private Blur', 'Only eyes visible, rest blurred for privacy', '🌫️'),
        _creativeTile('Story Canvas', 'Draw + Voice + Text in one image', '✏️'),
        _creativeTile('Nambi Magic', 'Your photo becomes cartoon caring avatar', '✨'),
        _creativeTile('No Save Art', 'Art can be viewed but never saved/downloaded', '🚫'),
        _creativeTile('Caring Sticker AI', 'AI creates stickers from your words', '💜'),
      ],
    );
  }
}

// 4. CARING SPACE - Unique Feature
class CaringSpacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _featureCard('💜 Caring Score', 'Not likes. How much you cared for others. Kindness measured.', Colors.pinkAccent),
        _featureCard('🌙 Late Night Care', 'If friend is online at 2AM, NAMBI asks "want to talk?" automatically', Colors.indigoAccent),
        _featureCard('🤝 No Forward Promise', 'We promise - your private things never forwarded. Blockchain proof.', Colors.teal),
        _featureCard('🫂 Consent View', 'Receiver must click "I promise to care" before seeing private content', Colors.green),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Color(0xFF6C4DFF), borderRadius: BorderRadius.circular(16)),
          child: Text('"NAMBI means caring beyond sharing" - Built for trust, not trends 💜', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

Widget _featureCard(String title, String desc, Color color) {
  return Card(
    margin: EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: ListTile(
      leading: CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(Icons.check_circle, color: color)),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(desc),
    ),
  );
}

Widget _creativeTile(String title, String desc, String emoji) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Color(0xFF6C4DFF).withOpacity(0.2))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(emoji, style: TextStyle(fontSize: 32)),
      SizedBox(height: 8),
      Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 4),
      Text(desc, style: TextStyle(fontSize: 11, color: Colors.black54)),
    ]),
  );
}
