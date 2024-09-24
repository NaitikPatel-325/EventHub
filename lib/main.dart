import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/qr/view/generateqr.dart';
import 'auth/wrapper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/qr/view/QrOption.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'screens/createevent/view/create_Event_page.dart';
import 'screens/register_page/view/register_page.dart';
import 'screens/live_update/view/live_updates_page.dart';
import 'screens/profile_page/view/profile_page.dart';
import 'screens/feedback_page/views/feedback_page.dart';
import 'screens/notification_page/view/notifications_page.dart';
import 'auth/signup.dart';
import 'auth/login.dart';
import 'auth/forgot.dart';
import 'auth/signout.dart';
import 'home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['API_KEY']!,
        authDomain: dotenv.env['AUTH_DOMAIN']!,
        projectId: dotenv.env['PROJECT_ID']!,
        storageBucket: dotenv.env['STORAGE_BUCKET']!,
        messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
        appId: dotenv.env['APP_ID']!,
        measurementId: dotenv.env['MEASUREMENT_ID']!,
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
        home: const Wrapper(),
        routes: {
          '/home': (context) => const HomePage(),
          '/create-event': (context) => const CreateEventPage(),
          '/register': (context) => const RegisterPage(),
          '/live-updates': (context) =>  const LiveUpdatesPage(),
          '/profile': (context) =>  const ProfilePage(),
          '/feedback': (context) =>  const FeedbackPage(),
          '/notifications': (context) =>  const NotificationsPage(),
          '/wrapper': (context) =>  const Wrapper(),
          '/signup': (context) =>  const Signup(),
          '/login': (context) =>  const Login(),
          '/forgot': (context) =>  ForgotPasswordPage(),
          '/signout': (context) => SignOutPage(),
          '/qr-code': (context) => QrOptionsPage(),
          '/generate-qr': (context) => GenerateQR(),
        },

      );
  }
}
