import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';

import '../widgets/notification_bell.dart';

class ReturnCancellationSettingsPage extends StatefulWidget {
  const ReturnCancellationSettingsPage({super.key});

  @override
  State<ReturnCancellationSettingsPage> createState() => _ReturnCancellationSettingsPageState();
}

class _ReturnCancellationSettingsPageState extends State<ReturnCancellationSettingsPage> {
  int currentIndex = -1;

  void _onNavTapped(int index) {
    setState(() => currentIndex = index);
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/scan');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 0),
            child: NotificationBell(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: _onNavTapped,
        isMarketplace: false,
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  // Back + Title
                  Center(
                    child: Text(
                      "CANCELLATION",
                      style: GoogleFonts.kronaOne(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Back
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Back", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Return & Cancellation Items
                  _buildSettingItem(Icons.assignment_return_outlined, "Request return", "select product"),
                  _buildSettingItem(Icons.cancel_outlined, "Cancel order", "select order"),
                  _buildSettingItem(Icons.track_changes_outlined, "Refund Tracking", "3 Permission Allowed"),
                  _buildSettingItem(Icons.policy_outlined, "View return policy", "Click here"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
