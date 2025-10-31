import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';
import 'package:lit/ecommerce/wishlist_service.dart';
import 'package:lit/pages/notifications_page.dart'; // ✅ added import
import 'package:provider/provider.dart';
import 'package:lit/ecommerce/product_detail_page.dart';
import 'package:lit/ecommerce/cart_service.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),

      // 🟣 Custom Top Section like Cart Page
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Top Row: Menu Icon + Logo + Notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    Image.asset('assets/images/logo.png', height: 40),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NotificationsPage()),
                        );
                      },
                      child: const Icon(Icons.notifications, color: Colors.white, size: 26),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // 🔹 Back Option
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Back",
                        style: TextStyle(
                          color: Color(0xFFB388FF), // light purple
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: -1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/cart');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
        isMarketplace: true,
      ),

      // 🟣 Background & Wishlist Body
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/background.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 WISHLIST Title
                  Center(
                    child: Text(
                      'WISHLIST',
                      style: GoogleFonts.kronaOne(
                        fontSize: 24,
                        color: Colors.white,
                        letterSpacing: 5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 All Categories Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      child: const Text(
                        'All Categories',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🛒 Wishlist Items
                  Expanded(
                    child: Consumer<WishlistService>(
                      builder: (context, wishlist, child) {
                        if (wishlist.items.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Your Wishlist is',
                                  style: GoogleFonts.kronaOne(
                                    fontSize: 22,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Empty',
                                  style: GoogleFonts.kronaOne(
                                    fontSize: 22,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        return GridView.builder(
                          itemCount: wishlist.items.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.52,
                          ),
                          itemBuilder: (context, index) {
                            final item = wishlist.items[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailPage(product: item),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white24, width: 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      child: Image.asset(
                                        item['image'],
                                        width: double.infinity,
                                        height: 140,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['brand'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item['title'],
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Rs. ${item['price']}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              // Left: Add to Cart (gradient fill)
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 7),
                                                  decoration: BoxDecoration(
                                                    gradient: const RadialGradient(
                                                      center: Alignment(0.08, 0.08),
                                                      radius: 4.98,
                                                      colors: [
                                                        Color.fromRGBO(0, 0, 0, 0.8),
                                                        Color.fromRGBO(147, 51, 234, 0.4),
                                                      ],
                                                      stops: [0.0, 0.5],
                                                    ),
                                                    borderRadius: BorderRadius.circular(14),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Provider.of<CartService>(context, listen: false).add(item);
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          backgroundColor: Colors.white,
                                                          content: Text('Item added to cart', style: TextStyle(color: Colors.black)),
                                                          duration: Duration(seconds: 1),
                                                        ),
                                                      );
                                                    },
                                                    child: const Center(
                                                      child: Text(
                                                        'Add to Cart',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // Right: Remove (outlined)
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 7),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(14),
                                                    border: Border.all(color: const Color(0xFFB794F4), width: 1.6),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      wishlist.remove(item);
                                                    },
                                                    child: const Center(
                                                      child: Text(
                                                        'Remove',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
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
}
