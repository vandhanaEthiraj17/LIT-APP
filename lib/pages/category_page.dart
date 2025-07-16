import 'package:flutter/material.dart';
import 'package:lit/data/global_data.dart';
import 'package:lit/ecommerce/widgets/product_card.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';

import '../ecommerce/widgets/sortby_bottomsheet.dart';

class CategoryPage extends StatelessWidget {
  final String title;
  final String categoryKey;
  final String type;
  final String gender;

  const CategoryPage({
    super.key,
    required this.title,
    required this.categoryKey,
    required this.type,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredProducts = allProducts.where((product) {
      final matchCategory = categoryKey.toLowerCase() == 'shop all' ||
          product['category']?.toLowerCase() == categoryKey.toLowerCase();
      final matchType = product['type']?.toLowerCase() == type.toLowerCase();
      final matchGender = product['gender']?.toLowerCase() == gender.toLowerCase();
      return matchCategory && matchType && matchGender;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 41,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.favorite_border, color: Colors.white),
          ),
        ],
      ),

      body: Stack(
        children: [
          // 🔹 Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),

          // 🔹 Foreground Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.arrow_back, color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(Icons.search, color: Color(0xFFCDB3FF), size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'You can search items',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.tune, color: Colors.white, size: 20),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: const Color(0xFF1C1C1E),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (_) => const SortByBottomSheet(),
                          );
                        },
                      ),

                    ],
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.53,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onBuyNow: () {
                          Navigator.pushNamed(context, '/buy-now', arguments: product);
                        },
                      );
                    },
                  ),
                ),
              ),



            ],
          ),
        ],
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: -1,
        onTap: (index) {
          // Leave unchanged for navigation logic
        },
        isMarketplace: true,
      ),
    );
  }
}
