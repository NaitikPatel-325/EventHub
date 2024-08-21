import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home.dart';
import 'screens/createevent/view/create_Event_page.dart';
import 'screens/register_page/view/register_page.dart';
import 'screens/qr/view/qr_code_scanner_page.dart';
import 'screens/live_update/view/live_updates_page.dart';
import 'screens/profile_page/view/profile_page.dart';
import 'screens/feedback_page/views/feedback_page.dart';
import 'screens/notification_page/view/notifications_page.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  //
  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //       apiKey: "AIzaSyAIeo0PdUroqktnrlfmON68hd1dgIFpBdw",
  //       projectId: "eventhub-dc5a9",
  //       messagingSenderId: "157461399913",
  //       appId: "1:157461399913:web:0843d62acd313e1fe495f8",
  //     ),
  //   );
  // } else {
  //   await Firebase.initializeApp();
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Schyler'),
      home: const HomePage(),
      routes: {
        '/create-event': (context) => const CreateEventPage(),
        '/register': (context) => const RegisterPage(),
        '/qr-code': (context) => const QRCodeScannerPage(),
        '/live-updates': (context) => const LiveUpdatesPage(),
        '/profile': (context) => const ProfilePage(),
        '/feedback': (context) => const FeedbackPage(),
        '/notifications': (context) => const NotificationsPage(),
      },
    );
  }
}
