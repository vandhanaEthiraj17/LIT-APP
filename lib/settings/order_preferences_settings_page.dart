import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';

import '../widgets/notification_bell.dart';

class OrderPreferencesSettingsPage extends StatefulWidget {
  const OrderPreferencesSettingsPage({super.key});

  @override
  State<OrderPreferencesSettingsPage> createState() => _OrderPreferencesSettingsPageState();
}

class _OrderPreferencesSettingsPageState extends State<OrderPreferencesSettingsPage> {
  int currentIndex = -1;
  String _preferredPayment = "Axis bank Credit card ****2422";

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

  void _onItemTap(String title) async {
    if (title == "Default Shipping Address") {
      Navigator.pushNamed(context, '/shipping-address');
    } else if (title == "Preferred Payment") {
      final result = await Navigator.pushNamed(context, '/payment-methods');
      if (result != null && result is String) {
        setState(() {
          _preferredPayment = result;
        });
      }
    } else if (title == "Order History") {
      Navigator.pushNamed(context, '/order-history');
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
                      "PREFERENCES",
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

                  // Preferences Items
                  _buildSettingItem(Icons.location_on_outlined, "Default Shipping Address",
                      "12/4 Dubai street,\nDubai kuruku sandhu,\nDubai-604001", tapable: true),
                  _buildSettingItem(Icons.payment_outlined, "Preferred Payment", _preferredPayment, tapable: true),
                  _buildSettingItem(Icons.history, "Order History", "24 Orders", tapable: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String value, {bool tapable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
        onTap: tapable ? () => _onItemTap(title) : null,
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
