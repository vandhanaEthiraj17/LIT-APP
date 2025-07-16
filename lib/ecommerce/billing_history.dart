import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';

import '../widgets/notification_bell.dart';

class BillingHistoryPage extends StatefulWidget {
  const BillingHistoryPage({super.key});

  @override
  State<BillingHistoryPage> createState() => _BillingHistoryPageState();
}

class _BillingHistoryPageState extends State<BillingHistoryPage> {
  int _currentIndex = 0;

  final List<BillingEntry> billingEntries = [
    BillingEntry(
      title: "Monthly Plan",
      description: "Unlimited access",
      dateTime: DateTime.now().subtract(const Duration(hours: 2)),
      amount: "₹499",
      status: "Paid",
    ),
    BillingEntry(
      title: "Monthly Plan",
      description: "Unlimited access",
      dateTime: DateTime.now().subtract(const Duration(hours: 2)),
      amount: "₹499",
      status: "Paid",
    ),
    BillingEntry(
      title: "Gem Pack",
      description: "Purchased 100 Gems",
      dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      amount: "₹199",
      status: "Pending",
    ),
    BillingEntry(
      title: "Luxury Dress",
      description: "Luxury outfit from store",
      dateTime: DateTime.now().subtract(const Duration(days: 2)),
      amount: "₹799",
      status: "Failed",
    ),
  ];

  Map<String, List<BillingEntry>> _groupEntriesByDate(List<BillingEntry> entries) {
    final Map<String, List<BillingEntry>> grouped = {};

    for (var entry in entries) {
      final now = DateTime.now();
      final entryDate = DateTime(entry.dateTime.year, entry.dateTime.month, entry.dateTime.day);
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));

      String key;
      if (entryDate == today) {
        key = 'Today';
      } else if (entryDate == yesterday) {
        key = 'Yesterday';
      } else {
        key = '${entryDate.day}/${entryDate.month}/${entryDate.year}';
      }

      grouped.putIfAbsent(key, () => []).add(entry);
    }

    return grouped;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(
          child: Image.asset(
            'assets/images/logo.png', // 🟣 Replace with your logo asset
            height: 40,
          ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: NotificationBell(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // ✅ Fullscreen layout using SizedBox.expand
          SizedBox.expand(
            child: Stack(
              children: [
                // 🔹 Background image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // 🔹 Semi-transparent overlay
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Foreground Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Center(
                          child: Text(
                            "BILLING HISTORY",
                            style: GoogleFonts.kronaOne(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Back Button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                "Back",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Grouped Billing History
                        ..._groupEntriesByDate(billingEntries).entries.map((entryGroup) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entryGroup.key,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...entryGroup.value.map((entry) => _buildBillingCard(entry)).toList(),

                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )

        ],
      ),


      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
  Widget _buildBillingCard(BillingEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                entry.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${entry.dateTime.hour.toString().padLeft(2, '0')}:${entry.dateTime.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(fontSize: 12, color: Colors.white38),
              ),
            ],
          ),

          // Right Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.amount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                entry.status,
                style: TextStyle(
                  fontSize: 13,
                  color: entry.status == "Paid"
                      ? Colors.greenAccent
                      : entry.status == "Pending"
                      ? Colors.amber
                      : Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

class BillingEntry {
  final String title;
  final String description;
  final DateTime dateTime;
  final String amount;
  final String status;

  BillingEntry({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.amount,
    required this.status,
  });
}

