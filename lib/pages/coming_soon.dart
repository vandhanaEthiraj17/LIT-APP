import 'package:flutter/material.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';
import '../widgets/notification_bell.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 🔹 Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)),

          // 🔹 Foreground content
          SafeArea(
            child: Column(
              children: [
                // 🔹 Top Navigation Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 40,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: NotificationBell(),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // 🔹 "Coming Soon" Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 40),

                      Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.deepPurple,
                        period: const Duration(milliseconds: 4000),
                        child: Text(
                          "COMMING\nSOON",
                          style: GoogleFonts.kronaOne(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Colors.white, // This is overridden by shimmer colors
                            height: 1.1,
                            letterSpacing: 2.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        "We're working hard to bring you this feature.\nStay tuned for the launch!",
                        style: GoogleFonts.kronaOne(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child: Text(
                          "Return to Homepage",
                          style: GoogleFonts.kronaOne(
                            color: Colors.deepPurpleAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),
                const SizedBox(height: 80), // bottom padding for nav bar
              ],
            ),
          ),
        ],
      ),

      // 🔹 Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: -1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/ir-icon');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
