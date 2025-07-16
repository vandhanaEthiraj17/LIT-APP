import 'package:flutter/material.dart';

class LuxurySustainableSection extends StatelessWidget {
  const LuxurySustainableSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shop Luxury &\nSustainable Fashion',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          buildInfoCard(
            context: context,
            title: 'SUSTAINABLE',
            description:
            'Our sustainable e-commerce platform offers a curated selection of eco-friendly products.',
            imagePath: 'assets/images/women.png',
            screenWidth: screenWidth,
            targetRoute: '/marketplace/sustainable',
          ),
          const SizedBox(height: 20),
          buildInfoCard(
            context: context,
            title: 'LUXURY',
            description:
            'Our luxury e-commerce platform offers a curated selection of the finest products.',
            imagePath: 'assets/images/men.png',
            screenWidth: screenWidth,
            targetRoute: '/marketplace/luxury',
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard({
    required BuildContext context,
    required String title,
    required String description,
    required String imagePath,
    required double screenWidth,
    required String targetRoute,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, targetRoute);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0.08, 0.08),
                        radius: 7.98,
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.8),
                          Color.fromRGBO(147, 51, 234, 0.4),
                        ],
                        stops: [0.0, 0.5],
                      ),
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: Color(0xFFAEAEAE),
                          width: 1,
                        ),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x66000000),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Shop Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 100,
              height: 170,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
