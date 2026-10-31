import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const NambiApp());
}

class NambiApp extends StatelessWidget {
  const NambiApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NAMBI Secure',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark, scaffoldBackgroundColor: Colors.black),
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
  String lang = 'tanglish'; // tamil, english, tanglish, hindi
  int todayCount = 0;
  bool isPremium = false;
  final int dailyLimit = 20;

  Map<String, Map<String, String>> t = {
    'tamil': {
      'title': 'NAMBI',
      'subtitle': '100% பாதுகாப்பானது - உங்கள் போட்டோ யாருக்கும் போகாது',
      'secure': '🔒 பாதுகாப்பு உத்தரவாதம்',
      'p1': '✓ உங்கள் டேட்டாவை யாருக்கும் கொடுக்க மாட்டோம்',
      'p2': '✓ 24 மணி நேரத்தில் ஆட்டோ டெலிட்',
      'p3': '✓ AI ட்ரெயினிங்கிற்கு பயன்படுத்த மாட்டோம்',
      'count': 'இன்று',
      'free': 'இலவசம்',
      'create': 'புது போட்டோ உருவாக்கு',
      'edit': 'போட்டோ எடிட் பண்ணு',
      'limitOver': 'டேய் 20 முடிஞ்சிடுச்சு!',
      'payMsg': 'நாளைக்கு ஃப்ரீயா வரும், இல்ல 49 ரூபாயில் 90 நாள் அன்லிமிடெட் எடுத்துக்கோ',
      'payBtn': '49 ரூபாய் - 90 நாள் செலுத்து',
    },
    'english': {
      'title': 'NAMBI',
      'subtitle': '100% Secure - Your photo never goes to anyone',
      'secure': '🔒 SECURE PROMISE',
      'p1': '✓ We never share your data',
      'p2': '✓ Auto-delete in 24 hours',
      'p3': '✓ Never used for AI training',
      'count': 'Today',
      'free': 'FREE',
      'create': 'Create New Photo',
      'edit': 'Edit Photo',
      'limitOver': 'Daily limit over da!',
      'payMsg': 'Comes free tomorrow, or get 90 days unlimited for Rs.49',
      'payBtn': 'Pay Rs.49 - 90 Days',
    },
    'tanglish': {
      'title': 'NAMBI',
      'subtitle': '100% Secure da - Un Photo Yaarukkum Pogathu da',
      'secure': '🔒 SECURE DA - NAMBALAM',
      'p1': '✓ Un data va yaarukkum tharamattom da',
      'p2': '✓ 24 hours la auto delete aagidum da',
      'p3': '✓ AI training ku use pannamattom da',
      'count': 'Innaiku',
      'free': 'FREE da',
      'create': 'Pudhu Photo Create Pannu da',
      'edit': 'Photo Edit Pannu da',
      'limitOver': 'Dei 20 mudinjiduchu da!',
      'payMsg': 'Nalaiku free ah varum da, illa 49 Rs la 90 days unlimited eduthukko da!',
      'payBtn': 'Pay 49 Rs - 90 Days da',
    },
    'hindi': {
      'title': 'NAMBI',
      'subtitle': '100% सुरक्षित - आपका फोटो किसी को नहीं जाएगा',
      'secure': '🔒 सुरक्षित वादा',
      'p1': '✓ आपका डेटा किसी को नहीं देंगे',
      'p2': '✓ 24 घंटे में ऑटो डिलीट',
      'p3': '✓ AI ट्रेनिंग के लिए उपयोग नहीं करेंगे',
      'count': 'आज',
      'free': 'फ्री',
      'create': 'नया फोटो बनाएं',
      'edit': 'फोटो एडिट करें',
      'limitOver': 'आज की लिमिट खत्म!',
      'payMsg': 'कल फ्री आएगा, या 49 रुपये में 90 दिन अनलिमिटेड लें',
      'payBtn': '49 रुपये दें - 90 दिन',
    },
  };

  @override
  void initState() {
    super.initState();
    loadCount();
  }

  Future<void> loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String lastDate = prefs.getString('lastDate') ?? '';
    if (lastDate != today) {
      await prefs.setString('lastDate', today);
      await prefs.setInt('todayCount', 0);
      setState(() => todayCount = 0);
    } else {
      setState(() => todayCount = prefs.getInt('todayCount') ?? 0);
    }
    setState(() => isPremium = prefs.getBool('isPremium') ?? false);
  }

  Future<void> useOne() async {
    if (isPremium) return;
    if (todayCount >= dailyLimit) {
      showPaywall();
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    setState(() => todayCount++);
    await prefs.setInt('todayCount', todayCount);
  }

  void showPaywall() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (_) => Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t[lang]!['limitOver']!, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Text(t[lang]!['payMsg']!, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15), border: Border.all(color: Color(0xFFFFD700))),
              child: Column(children: [
                Text('🔒 100% Secure & Private', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('✓ Unlimited Photos\n✓ HD Quality\n✓ No Watermark\n✓ Auto-delete still ON', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ]),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFD700), padding: EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                onPressed: () => payNow(),
                child: Text(t[lang]!['payBtn']!, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> payNow() async {
    // Razorpay Payment Link - un link ah inga maathu da
    final Uri url = Uri.parse('https://rzp.io/l/YOUR_PAYMENT_LINK');
    // For testing, open UPI
    // final Uri upi = Uri.parse('upi://pay?pa=your-upi@okicici&pn=NAMBI&am=49&cu=INR');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Fallback - mark premium locally for demo
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isPremium', true);
      setState(() => isPremium = true);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Premium Activated da! (Demo)')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Language Switcher
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                langBtn('tamil', 'தமிழ்'),
                langBtn('tanglish', 'Tanglish'),
                langBtn('english', 'English'),
                langBtn('hindi', 'हिंदी'),
              ]),
              SizedBox(height: 25),
              // Logo
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(25), border: Border.all(color: Color(0xFFFFD700), width: 2)),
                child: Stack(alignment: Alignment.center, children: [
                  Text('N', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
                  Positioned(top: 5, child: Text('👑', style: TextStyle(fontSize: 20))),
                ]),
              ),
              SizedBox(height: 15),
              Text(t[lang]!['title']!, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4, color: Colors.white)),
              Text(t[lang]!['subtitle']!, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
              SizedBox(height: 20),
              // Count Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(15)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${t[lang]!['count']}: $todayCount / $dailyLimit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(isPremium ? 'Premium Active da! Unlimited' : '${dailyLimit - todayCount} ${t[lang]!['free']}', style: TextStyle(color: isPremium ? Color(0xFFFFD700) : Colors.green)),
                  ]),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(color: todayCount >= dailyLimit && !isPremium ? Colors.red : Color(0xFFFFD700), borderRadius: BorderRadius.circular(20)),
                    child: Text(todayCount >= dailyLimit && !isPremium ? 'LIMIT OVER' : 'ACTIVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ]),
              ),
              SizedBox(height: 20),
              // Create & Edit Buttons
              Row(children: [
                Expanded(child: actionBtn(Icons.auto_awesome, t[lang]!['create']!, () => useOne())),
                SizedBox(width: 12),
                Expanded(child: actionBtn(Icons.edit, t[lang]!['edit']!, () => useOne())),
              ]),
              SizedBox(height: 25),
              // Secure Card - MAIN USP
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: Color(0xFF111111), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t[lang]!['secure']!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFFD700))),
                  SizedBox(height: 12),
                  secureRow(t[lang]!['p1']!),
                  secureRow(t[lang]!['p2']!),
                  secureRow(t[lang]!['p3']!),
                  SizedBox(height: 10),
                  Text('Your data stays yours. We never sell. Never share.', style: TextStyle(color: Colors.white38, fontSize: 11)),
                ]),
              ),
              SizedBox(height: 20),
              Text('App + Website Same Code | Works Everywhere', style: TextStyle(color: Colors.white24, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget langBtn(String code, String label) {
    bool sel = lang == code;
    return GestureDetector(
      onTap: () => setState(() => lang = code),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: sel ? Color(0xFFFFD700) : Colors.white10, borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: TextStyle(color: sel ? Colors.black : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget actionBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(color: Color(0xFFFFD700), borderRadius: BorderRadius.circular(18)),
        child: Column(children: [
          Icon(icon, color: Colors.black, size: 28),
          SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
        ]),
      ),
    );
  }

  Widget secureRow(String txt) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Text(txt, style: TextStyle(color: Colors.white70, fontSize: 13)));
  }
}
