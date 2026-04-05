import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Menu',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            _buildMenuItem(
              icon: Icons.person,
              title: 'Profile',
              subtitle: 'View and edit your profile',
              onTap: () {
                _showComingSoon(context);
              },
            ),
            _buildMenuItem(
              icon: Icons.favorite,
              title: 'Favorites',
              subtitle: 'Your saved content',
              onTap: () {
                _showComingSoon(context);
              },
            ),
            _buildMenuItem(
              icon: Icons.history,
              title: 'History',
              subtitle: 'View your recent activities',
              onTap: () {
                _showComingSoon(context);
              },
            ),
            _buildMenuItem(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Manage notification settings',
              onTap: () {
                _showComingSoon(context);
              },
            ),
            _buildMenuItem(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'App preferences and customization',
              onTap: () {
                _showComingSoon(context);
              },
            ),
            _buildMenuItem(
              icon: Icons.help,
              title: 'Help & Support',
              subtitle: 'FAQs and contact support',
              onTap: () {
                _showComingSoon(context);
              },
            ),
            _buildMenuItem(
              icon: Icons.share,
              title: 'Share App',
              subtitle: 'Share Make Your Day with friends',
              onTap: () {
                _showComingSoon(context);
              },
            ),
            _buildMenuItem(
              icon: Icons.info,
              title: 'About',
              subtitle: 'Version 1.0.0',
              onTap: () {
                _showComingSoon(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('This feature is coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
