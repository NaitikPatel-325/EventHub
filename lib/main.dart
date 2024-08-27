import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/wrapper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'screens/createevent/view/create_Event_page.dart';
import 'screens/register_page/view/register_page.dart';
import 'screens/live_update/view/live_updates_page.dart';
import 'screens/profile_page/view/profile_page.dart';
import 'screens/feedback_page/views/feedback_page.dart';
import 'screens/notification_page/view/notifications_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD-FZkaeQ-DJG6Nkl_Kqjmkaa0XueHfzuE",
        authDomain: "eventhub-64c1d.firebaseapp.com",
        projectId: "eventhub-64c1d",
        storageBucket: "eventhub-64c1d.appspot.com",
        messagingSenderId: "79782838207",
        appId: "1:79782838207:web:b64fc41969a89f3c296b0a",
        measurementId: "G-0HS1JX5B6K",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Schyler'),
      home: Wrapper(),
      routes: {
        '/create-event': (context) => const CreateEventPage(),
        '/register': (context) => const RegisterPage(),
        '/live-updates': (context) => const LiveUpdatesPage(),
        '/profile': (context) => const ProfilePage(),
        '/feedback': (context) => const FeedbackPage(),
        '/notifications': (context) => const NotificationsPage(),
      },
    );
  }
}
