import 'package:flutter/material.dart';
import 'lit_game_section.dart';
import 'fashion_section.dart';
import 'newsletter_section.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double _topInset = kToolbarHeight + MediaQuery.of(context).padding.top;
    return Stack(
      children: [
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
        Padding(
          padding: EdgeInsets.only(top: _topInset),
          child: const SingleChildScrollView(
            child: Column(
              children: [
                LitGameSection(),
                SizedBox(height: 22),
                LuxurySustainableSection(),
                SizedBox(height: 22),
                NewsletterSection(),
                SizedBox(height: 22),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
