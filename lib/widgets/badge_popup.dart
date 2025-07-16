import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class BadgePopupDialog extends StatelessWidget {
  const BadgePopupDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        clipBehavior: Clip.none, // 👈️ allows overflow (e.g. -top offset)
        children: [
          // Main Dialog Content
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "BADGES",
                      style: GoogleFonts.kronaOne(
                        fontSize: 16,
                        letterSpacing: 2,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 1,
                      color: Colors.white24,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _badgeColumn("assets/images/beginner.png", "BEGINNER"),
                        _badgeColumn("assets/images/amateur.png", "AMATEUR"),
                        _badgeColumn("assets/images/connoisseur.png", "CONNOISSEUR"),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Win 11 Games to achieve the Beginner Badge",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ❌ Cancel Button Floating Above
          Positioned(
            top: -0, // pull it above the dialog
            right: -0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Container(
                color: const Color(0xFF2D0C4B),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFFE0BBFF)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _badgeColumn(String asset, String title) {
    return Column(
      children: [
        Image.asset(asset, height: 65),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
