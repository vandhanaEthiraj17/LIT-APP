import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';
import '../widgets/notification_bell.dart';
import './dialog/subscription_dialogs.dart';

class SubscriptionSettingsPage extends StatefulWidget {
  const SubscriptionSettingsPage({super.key});

  @override
  State<SubscriptionSettingsPage> createState() => _SubscriptionSettingsPageState();
}

class _SubscriptionSettingsPageState extends State<SubscriptionSettingsPage> {
  int currentIndex = -1;

  String currentPlan = "Free";
  String paymentMethod = "Axis Bank Credit card ****2422";
  final List<String> paymentMethods = [
    "Axis Bank Credit card ****2422",
    "HDFC Debit card ****1100",
    "Google Pay",
    "PhonePe",
  ];

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
    if (title == "Upgrade or Downgrade Plan" || title == "Plan Benefits Overview") {
      Navigator.pushNamed(context, '/subscription-plan-details');
    } else if (title == "Payment Method") {
      final result = await Navigator.pushNamed(
        context,
        '/payment-methods',
        arguments: paymentMethod, // 👈 pass current selected method
      );

      if (result is String && result.isNotEmpty) {
        setState(() => paymentMethod = result);
      }
    } else if (title == "Billing History") {
      Navigator.pushNamed(context, '/billing-history');
    } else if (title == "Auto-Renewal Toggle") {
      showAutoRenewalDialog(context);
    }
  }


  String _getPlanBenefits(String plan) {
    switch (plan) {
      case "Free":
        return "Free";
      case "Premium":
        return "Premium";
      case "Premium+":
        return "Premium+";
      default:
        return "Free";
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
                      "SUBSCRIPTION",
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

                  // Subscription Items
                  _buildSettingItem(Icons.subscriptions_outlined, "Current Plan", currentPlan),
                  _buildSettingItem(Icons.info_outline, "Plan Benefits Overview", _getPlanBenefits(currentPlan), tapable: true),
                  _buildSettingItem(Icons.swap_vert_circle_outlined, "Upgrade or Downgrade Plan", "", tapable: true),
                  _buildSettingItem(Icons.payment_outlined, "Payment Method", paymentMethod, tapable: true),
                  _buildSettingItem(Icons.receipt_long_outlined, "Billing History", "View", tapable: true),
                  _buildSettingItem(Icons.autorenew_outlined, "Auto-Renewal Toggle", "", tapable: true),

                  const SizedBox(height: 10),

                  // Cancel Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Add cancel subscription logic
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),

                          color: Colors.redAccent.withOpacity(0.1),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cancel_outlined, color: Colors.redAccent),
                            SizedBox(width: 8),
                            Text(
                              "Cancel Subscription",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                    if (value.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
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
