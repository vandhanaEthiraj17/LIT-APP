import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';
import '../widgets/notification_bell.dart';
import './dialog/privacy_option_dialog.dart';
import './dialog/toggle_option_dialog.dart';
import './dialog/permission_list_dialog.dart';

class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  int currentIndex = -1;
  String profileVisibility = "Public";
  String adPersonalization = "Turn Off";
  String appPermissions = "3 Permission Allowed";


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
                  // Title
                  Center(
                    child: Text(
                      "PRIVACY",
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

                  // Privacy Items
                  _buildPrivacyItem(Icons.person_outline, "Profile Visibility", profileVisibility, (val) {
                    setState(() => profileVisibility = val);
                  }),
                  _buildPrivacyItem(Icons.security_outlined, "App Permission", appPermissions, (val) {
                    setState(() => appPermissions = val);
                  }),
                  _buildPrivacyItem(Icons.cloud_download_outlined, "Download My data", "Click here", (val) {}),
                  _buildPrivacyItem(Icons.privacy_tip_outlined, "Ad Personalization", adPersonalization, (val) {
                    setState(() => adPersonalization = val);
                  }),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyItem(
      IconData icon,
      String title,
      String value,
      void Function(String newValue) onValueChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (title == "Download My data") {
              // Implement data download logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Data download started...")),
              );
              return;
            }

            if (title == "Profile Visibility") {
              showDialog(
                context: context,
                builder: (_) => PrivacyOptionDialog(
                  title: "Profile Visibility",
                  currentValue: value,
                  options: const ["Public", "Private", "Friends Only"],
                  onChanged: onValueChanged,
                ),
              );
            } else if (title == "Ad Personalization") {
              showDialog(
                context: context,
                builder: (_) => ToggleOptionDialog(
                  title: "Ad Personalization",
                  initialValue: value == "Turn On",
                  onChanged: (bool turnedOn) {
                    onValueChanged(turnedOn ? "Turn On" : "Turn Off");
                  },
                ),
              );
            } else if (title == "App Permission") {
              showDialog(
                context: context,
                builder: (_) => PermissionListDialog(
                  initialPermissions: {
                    "Location": true,
                    "Camera": true,
                    "Gallery": true,
                  },
                  onPermissionsChanged: (updated) {
                    final allowed = updated.entries.where((e) => e.value).length;
                    onValueChanged("$allowed Permission Allowed");
                  },
                ),
              );
            }

          },
          child: Row(
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
        ),
        const SizedBox(height: 24),
      ],
    );
  }

}
