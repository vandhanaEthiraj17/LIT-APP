import 'package:flutter/material.dart';

class LitFeaturesSection extends StatelessWidget {
  const LitFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "All-in-One LIT",
            style: TextStyle(
              fontSize:40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const Text(
            "Features",
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 22),

          // Features Grid
          LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = constraints.maxWidth;
              double cardWidth = (maxWidth - 20) / 2; // 20 spacing between columns

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _buildFeatureCard(
                    title: "Style Pick Game",
                    description: "Guess which fashion item is more expensive — luxury or affordable.",
                    width: cardWidth,
                  ),
                  _buildFeatureCard(
                    title: "E-Commerce",
                    description: "Seamless shopping meets smart style.",
                    width: cardWidth,
                  ),
                  _buildFeatureCard(
                    title: "LIT NewsFlash",
                    description: "Stay updated with real-world knowledge.",
                    width: cardWidth,
                  ),
                  _buildFeatureCard(
                    title: "IR-Based Insights",
                    description: "Smart tracking & personalized data with Information Retrieval.",
                    width: cardWidth,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required double width,
  }) {
    return Container(
      width: width,
      height: 208,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo/Icon
          Image.asset(
            "assets/images/logo.png", // Replace with your actual logo
            height: 32,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Learn More
          Row(
            children: const [
              Text(
                "Learn more",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
