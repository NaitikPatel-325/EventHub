import 'package:flutter/material.dart';
import 'widgets/app_bar.dart';
import 'widgets/drawer.dart';
import 'widgets/carousel.dart';
import 'widgets/statistics.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDarkMode = false;
  int _selectedIndex = 0; 
  int _drawerSelectedIndex = 0; 

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.popUntil(context, (route) => route.isFirst);
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/create-event');
        break;
      case 1:
        Navigator.pushNamed(context, '/register');
        break;
      case 2:
        Navigator.pushNamed(context, '/myevent');
        break;
      default:
        break;
    }
  }

  void _onNavItemDrawerTapped(int index) {
    setState(() {
      _drawerSelectedIndex = index;
    });
    Navigator.popUntil(context, (route) => route.isFirst);
    switch (index) {
      case 0:
      Navigator.pushNamed(context, '/profile');
      break;
    case 1:
      Navigator.pushNamed(context, '/feedback');
      break;
    case 2:
      Navigator.pushNamed(context, '/signout');
      break;
    }  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: buildAppBar(context),
        drawer: buildDrawer(context, _toggleDarkMode, _isDarkMode, _onNavItemDrawerTapped),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const <Widget>[
            Carousel(imgList: [
              'assets/images/image1.png',
              'assets/images/image2.png',
              'assets/images/image3.png',
            ]),
            SizedBox(height: 16.0),
            Statistics(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Create Event'),
            BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Register'),
            BottomNavigationBarItem(icon: Icon(Icons.abc_outlined),label: 'My Events'),
          ],
          selectedItemColor:Colors.deepPurpleAccent,
          unselectedItemColor:Colors.deepPurpleAccent,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}

