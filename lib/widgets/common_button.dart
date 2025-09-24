import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lit/data/global_data.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isMarketplace; // 🔹 NEW PARAMETER
  final bool isGame;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isMarketplace = false, // 🔹 DEFAULT VALUE
    this.isGame = false,
  });

  void addToCart(BuildContext context, Map<String, dynamic> product) {
    cartItems.add(product); // This must be a global/shared list
  }


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.08, 0.08),
              radius: 15.98,
              colors: [
                Color.fromRGBO(0, 0, 0, 0.8),
                Color.fromRGBO(147, 51, 234, 0.4),
              ],
              stops: [0.0, 0.5],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 30,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SizedBox(
            height: 60,
            child: BottomAppBar(
              color: Colors.transparent,
              elevation: 0,
              shape: const CircularNotchedRectangle(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 🔹 Home Icon
                    GestureDetector(
                      onTap: () => onTap(0),
                      child: Image.asset(
                        'assets/images/home_icon.png',
                        width: 28,
                        height: 28,
                        color: currentIndex == 0
                            ? const Color(0x718D00FF)
                            : Colors.white,
                      ),
                    ),

                    // 🔹 Save/Cart/IR Icon
                    GestureDetector(
                      onTap: () {
                        if (isGame) {
                          Navigator.pushNamed(context, '/save-products');
                        } else if (isMarketplace) {
                          Navigator.pushNamed(context, '/cart', arguments: cartItems);
                        } else {
                          Navigator.pushNamed(context, '/ir-icon');
                        }
                      },
                      child: Image.asset(
                        isGame
                            ? 'assets/images/save-pro-icon.png'
                            : isMarketplace
                                ? 'assets/images/grocery-store.png'
                                : 'assets/images/ir_icon.png',
                        width: 28,
                        height: 28,
                        color: currentIndex == 1 ? const Color(0x718D00FF) : Colors.white,
                      ),
                    ),

                    // 🔹 Cart Icon (only in Game) — placed between save-pro and profile
                    if (isGame)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/cart', arguments: cartItems);
                        },
                        child: Image.asset(
                          'assets/images/grocery-store.png',
                          width: 28,
                          height: 28,
                          color: Colors.white,
                        ),
                      ),

                    // 🔹 Profile Icon
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                      child: Image.asset(
                        'assets/images/profile_icon.png',
                        width: 28,
                        height: 28,
                        color: currentIndex == 2
                            ? const Color(0x718D00FF)
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
