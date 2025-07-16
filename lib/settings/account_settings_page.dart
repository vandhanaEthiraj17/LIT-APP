import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';
import '../widgets/notification_bell.dart';
import './dialog/edit_field_dialog.dart';
import './dialog/change_password_dialog.dart';
import './dialog/two_factor_dialog.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  int currentIndex = -1;

  // 👇 These variables store the field values
  String userName = "Luxuryintaste";
  String userPhone = "+91 9874563210";
  String userEmail = "luxuryintatse@gmail.com";
  String userPassword = "********";
  String user2FA = "Turn Off";
  String connectedDevices = "2 devices";

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

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  // Header
                  Center(
                    child: Text(
                      "ACCOUNT",
                      style: GoogleFonts.kronaOne(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Back
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

                  _buildAccountItem(Icons.person_outline, "Name", userName, (val) {
                    setState(() => userName = val);
                  }),
                  _buildAccountItem(Icons.phone_outlined, "Phone", userPhone, (val) {
                    setState(() => userPhone = val);
                  }),
                  _buildAccountItem(Icons.email_outlined, "Email", userEmail, (val) {
                    setState(() => userEmail = val);
                  }),
                  _buildAccountItem(Icons.lock_outline, "Change Password", "********", (val) {
                    setState(() => userPassword = val);
                  }),

                  _buildAccountItem(Icons.shield_outlined, "Two-Factor Authentication", user2FA, (val) {
                    setState(() => user2FA = val);
                  }),
                  _buildAccountItem(Icons.devices_other, "Connected devices", connectedDevices, (val) {
                    setState(() => connectedDevices = val);
                  }),

                  const SizedBox(height: 10),

                  // Delete Button (not full width, with icon)
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // TODO: Add delete account logic
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.red.withOpacity(0.1),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete_outline, color: Colors.redAccent),
                              SizedBox(width: 8),
                              Text(
                                "Delete Account",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem(
      IconData icon,
      String title,
      String value,
      void Function(String) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (title == "Connected devices") return; // 🔥 Skip dialog
            if (title == "Change Password") {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => ChangePasswordDialog(
                  onSave: (oldPwd, newPwd) {
                    onChanged(newPwd); // update the password
                  },
                ),
              );
            }
            else if (title == "Two-Factor Authentication") {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => TwoFactorDialog(
                  initialValue: value == "Turn On",
                  onChanged: (bool newVal) {
                    onChanged(newVal ? "Turn On" : "Turn Off");
                  },
                ),
              );
            }
            else {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => EditFieldDialog(
                  fieldLabel: title,
                  initialValue: value,
                  onFieldSaved: (newValue) {
                    onChanged(newValue); // update the corresponding field
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
