import 'dart:math';
import 'package:flutter/material.dart';

class LitGameSection extends StatelessWidget {
  const LitGameSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 46), // Space where header used to be

          // 🔹 Game Container with LIT GAME tab
          Stack(
            clipBehavior: Clip.none,
            children: [
              // 🟪 Game Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 18, bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white, width: 2),
                  color: const Color(0xFF1B0428).withOpacity(0.85),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildShoeCard('assets/images/violet-shoe.png', -pi / 15),
                        const SizedBox(width: 8),
                        // 🎨 VS Text with outline and gradient
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              'VS',
                              style: TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w900,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 4
                                  ..color = Colors.black,
                              ),
                            ),
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: [
                                    Color(0xFFB497D6),
                                    Color(0xFF6B4F9E),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: const Text(
                                'VS',
                                style: TextStyle(
                                  fontSize: 46,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        buildShoeCard('assets/images/blue-shoe.png', pi / 15),
                      ],
                    ),
                  ],
                ),
              ),

              // 🛑 Mask top border behind tab
              Positioned(
                top: -2,
                left: screenWidth * 0.25,
                right: screenWidth * 0.25,
                child: Container(
                  height: 12,
                  color: const Color(0xFF1B0428),
                ),
              ),

              // 🟪 LIT GAME Tab
              Positioned(
                top: -20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF200D33),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Text(
                      'LIT GAME',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 🔹 Play Now Button
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context,'/game-entrance' );
            },
            child: Container(
              width: screenWidth * 0.5,
              padding: const EdgeInsets.symmetric(vertical: 14),
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
              child: const Center(
                child: Text(
                  "Play Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// 🟦 Shoe Card
  Widget buildShoeCard(String imgPath, double angle) {
    return Transform.rotate(
      angle: angle,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: 100,
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(2, 10),
              ),
            ],
            color: Colors.transparent,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    color: const Color(0xFFEDEDED),
                    alignment: Alignment.center,
                    child: Image.asset(
                      imgPath,
                      height: 95,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: const Text(
                      '???',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
