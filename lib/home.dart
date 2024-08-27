import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDarkMode = false;
  int _selectedIndex = 0;

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  void _onNavItemTapped(int index) {
    if (index < 4) {
      setState(() {
        _selectedIndex = index;
        _navigateToPage(index);
      });
    } else {
      _navigateToPage(index);
    }
  }

  void _navigateToPage(int index) {
    Navigator.popUntil(context, (route) => route.isFirst);
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/create-event').then((_) {
          setState(() {
            _selectedIndex = 0;
          });
        });
        break;
      case 1:
        Navigator.pushNamed(context, '/register');
        break;
      case 2:
        Navigator.pushNamed(context, '/qr-code');
        break;
      case 3:
        Navigator.pushNamed(context, '/notifications');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile').then((_) {
          setState(() {
            _selectedIndex = 0; // Reset to a valid index
          });
        });
        break;
      case 5:
        Navigator.pushNamed(context, '/feedback').then((_) {
          setState(() {
            _selectedIndex = 0; // Reset to a valid index
          });
        });
        break;
        case 7:
        Navigator.pushNamed(context, '/signout').then((_) {
          setState(() {
            _selectedIndex = 0; // Reset to a valid index
          });
        });
        break;
    }
  }



  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'assets/images/image1.png',
      'assets/images/image2.png',
      'assets/images/image3.png',
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Event Management',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              color: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: const Text(
                  'EventHub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildDrawerItem(
                context,
                Icons.person,
                'Profile',
                4,
              ),
              _buildDrawerItem(
                context,
                Icons.event,
                'Create & Manage Events',
                0,
              ),
              _buildDrawerItem(
                context,
                Icons.person_add,
                'Register for Events',
                1,
              ),
              _buildDrawerItem(
                context,
                Icons.qr_code_scanner,
                'QR Code',
                2,
              ),
              _buildDrawerItem(
                context,
                Icons.notifications,
                'Live Updates',
                3,
              ),
              _buildDrawerItem(
                context,
                Icons.feedback,
                'Feedback',
                5,
              ),
              ListTile(
                leading: const Icon(
                  Icons.dark_mode,
                  color: Colors.blue,
                ),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: _isDarkMode,
                  onChanged: _toggleDarkMode,
                ),
              ),
              _buildDrawerItem(
                context,
                Icons.logout_outlined,
                'Logout',
                7,
              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            // Carousel Slider
            CarouselSlider.builder(
              itemCount: imgList.length,
              itemBuilder: (context, index, realIndex) {
                final imgUrl = imgList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(imgUrl, fit: BoxFit.cover),
                  ),
                );
              },
              options: CarouselOptions(
                height: 200.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16/9,
                viewportFraction: 0.9,
              ),
            ),
            const SizedBox(height: 16.0),
            // Statistical Data
            _buildStatistics(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Create Event',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: 'Register',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: 'QR Code',
            ),
            
          ],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.blue,
          showUnselectedLabels: true,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context,
      IconData icon,
      String title,
      int index,
      ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: () {
        _onNavItemTapped(index);
      },
    );
  }

  Widget _buildStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Event Statistics',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16.0),
        Card(
          elevation: 4.0,
          child: const ListTile(
            title: Text('Total Events'),
            subtitle: Text('15'),
            leading: Icon(Icons.event, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 8.0),
        Card(
          elevation: 4.0,
          child: const ListTile(
            title: Text('Upcoming Registrations'),
            subtitle: Text('25'),
            leading: Icon(Icons.person_add, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 8.0),
        Card(
          elevation: 4.0,
          child: const ListTile(
            title: Text('QR Codes Scanned'),
            subtitle: Text('8'),
            leading: Icon(Icons.qr_code_scanner, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 8.0),
        Card(
          elevation: 4.0,
          child: const ListTile(
            title: Text('Live Updates Sent'),
            subtitle: Text('5'),
            leading: Icon(Icons.notifications, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}