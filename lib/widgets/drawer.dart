import 'package:flutter/material.dart';

Widget buildDrawer(
  BuildContext context,
  Function(bool) toggleDarkMode,
  bool isDarkMode,
  Function(int) onNavItemDrawerTapped,
) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'EventHub',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildDrawerItem(context, Icons.person, 'Profile', 0, onNavItemDrawerTapped),
        _buildDrawerItem(context, Icons.feedback, 'Feedback', 1, onNavItemDrawerTapped),
        ListTile(
          leading: const Icon(Icons.dark_mode, color: Colors.blue),
          title: const Text('Dark Mode'),
          trailing: Switch(
            value: isDarkMode,
            onChanged: toggleDarkMode,
          ),
        ),
        _buildDrawerItem(context, Icons.logout_outlined, 'Logout', 2, onNavItemDrawerTapped),
      ],
    ),
  );
}

Widget _buildDrawerItem(BuildContext context, IconData icon, String title, int index, Function(int) onNavItemTapped) {
  return ListTile(
    leading: Icon(icon, color: Colors.blue),
    title: Text(title),
    onTap: () {
      onNavItemTapped(index);
    },
  );
}
