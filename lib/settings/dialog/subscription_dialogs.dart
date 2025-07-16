import 'dart:ui';

import 'package:flutter/material.dart';

void showUpgradePlanDialog(BuildContext context, String currentPlan, Function(String) onSelected) {
  List<String> plans = ['Free', 'Premium', 'Premium+'];
  String tempPlan = currentPlan;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.black87,
      title: const Text("Select Plan", style: TextStyle(color: Colors.white)),
      content: StatefulBuilder(
        builder: (context, setStateDialog) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: plans.map((plan) {
              return RadioListTile<String>(
                value: plan,
                groupValue: tempPlan,
                onChanged: (val) {
                  setStateDialog(() => tempPlan = val!);
                },
                title: Text(plan, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
          );
        },
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.white70))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          onPressed: () {
            onSelected(tempPlan);
            Navigator.pop(context);
          },
          child: const Text("Save", style: TextStyle(color: Colors.black)),
        )
      ],
    ),
  );
}

void showPaymentMethodDialog(BuildContext context, List<String> methods, String selected, Function(String) onSelected) {
  String tempMethod = selected;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.black87,
      title: const Text("Select Payment Method", style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: tempMethod,
            dropdownColor: Colors.grey[900],
            isExpanded: true,
            style: const TextStyle(color: Colors.white),
            iconEnabledColor: Colors.white,
            underline: Container(height: 1, color: Colors.white),
            onChanged: (val) {
              if (val != null) {
                onSelected(val);
                Navigator.pop(context);
              }
            },
            items: methods.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              // Handle add payment method
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add Payment Method Clicked")));
            },
            child: const Text("Add Payment Method", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    ),
  );
}

void showAutoRenewalDialog(BuildContext context) {
  bool temp = false;

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setStateDialog) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Auto-Renewal",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Enable", style: TextStyle(color: Colors.white)),
                          Switch(
                            value: temp,
                            activeColor: const Color.fromRGBO(147, 51, 234, 0.4),
                            onChanged: (val) {
                              setStateDialog(() => temp = val);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              // Save state logic here
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: const RadialGradient(
                                  center: Alignment(0.08, 0.08),
                                  radius: 7.98,
                                  colors: [
                                    Color.fromRGBO(0, 0, 0, 0.8),
                                    Color.fromRGBO(147, 51, 234, 0.4),
                                  ],
                                  stops: [0.0, 0.5],
                                ),
                                border: Border.all(
                                  color: Color(0xFFAEAEAE),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x66000000),
                                    offset: Offset(0, 4),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

