import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/notification_bell.dart';
import 'package:lit/widgets/common_button.dart';

class OrderConfirmationPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  const OrderConfirmationPage({super.key, this.cartItems = const []});

  List<Map<String, dynamic>> _resolveCartItems(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['cartItems'] is List) {
      return (args['cartItems'] as List).cast<Map<String, dynamic>>();
    }
    return cartItems;
  }

  int _calcTotal(List<Map<String, dynamic>> items) {
    return items.fold(0, (sum, it) => sum + (it['price'] as int? ?? int.tryParse('${it['price']}') ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final items = _resolveCartItems(context);
    final total = _calcTotal(items);
    final product = items.isNotEmpty ? items.first : null;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/marketplace');
        return false;
      },
      child: Scaffold(
        drawer: const AppDrawer(),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          centerTitle: true,
          title: Image.asset('assets/images/logo.png', height: 40),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: NotificationBell(),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: -1,
          onTap: (i) {
            if (i == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (i == 1) {
              Navigator.pushReplacementNamed(context, '/scan');
            } else if (i == 2) {
              Navigator.pushReplacementNamed(context, '/profile');
            }
          },
          isMarketplace: false,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('assets/images/background.png', fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.65)),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Center(
                            child: Text(
                              'Order Confirmation',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Back",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 56,
                                height: 56,
                                child: Image.asset(
                                  'assets/images/Vector.png',
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.contain,
                                  errorBuilder: (ctx, err, stack) => const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Thank you!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Your order #BE12345 has been placed.',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(color: Colors.white, fontSize: 15),
                              children: [
                                TextSpan(text: 'We sent an email to '),
                                TextSpan(
                                  text: 'luxuryintastd@gmail.com',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                TextSpan(text: ' with your order confirmation and bill.'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Time placed: 17/02/2020 12:45 CEST',
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Shipping',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _addressCard(
                            title: 'luxuryintaste',
                            name: 'luxuryintaste',
                            email: 'luxuryintastd@gmail.com',
                            phone: '+91 9874563210',
                            address: 'Leibnizstraße 16, Wohnheim 6, No: 8X\nClausthal-Zellerfeld, Germany',
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Billing',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'SF Pro Display',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _addressCard(
                            title: 'luxuryintaste',
                            name: 'luxuryintaste',
                            email: 'luxuryintastd@gmail.com',
                            phone: '+91 9874563210',
                            address: 'Leibnizstraße 16, Wohnheim 6, No: 8X\nClausthal-Zellerfeld, Germany',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Order Items',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _arrivalBanner(),
                      const SizedBox(height: 12),

                      if (product != null) _orderItemCard(product),

                      const SizedBox(height: 24),
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _summaryRow('Cart Total', 'Rs. $total'),
                      _summaryRow('Savings', '-Rs. 900', color: const Color(0xFF7F34C3)),
                      _summaryRow('Platform Fee', 'Free'),
                      _summaryRow('Delivery Fee', 'Free'),
                      const Divider(color: Colors.white24),
                      _summaryRow('Total Amount', 'Rs. $total', isBold: true, fontSize: 18),

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF7F34C3)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => Navigator.pushReplacementNamed(context, '/marketplace'),
                          child: const Text('Back to Shopping', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _arrivalBanner() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Image.asset(
            'assets/images/delivery.png',
            width: 22,
            height: 22,
            fit: BoxFit.contain,
            errorBuilder: (ctx, err, stack) => const Icon(
              Icons.local_shipping_outlined,
              color: Colors.black54,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Arrives by April 3 to April 9th',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderItemCard(Map<String, dynamic> item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            item['image'] ?? 'assets/images/placeholder.png',
            width: 110,
            height: 110,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) => Container(
              width: 110,
              height: 110,
              color: Colors.white12,
              child: const Icon(Icons.image_not_supported, color: Colors.white54),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['brand'] ?? 'Brand',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                item['title'] ?? 'Product',
                style: const TextStyle(color: Colors.white70),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip('Size: ${item['size'] ?? 'M'}'),
                  _chip('Qty: ${item['quantity'] ?? 1}'),
                ],
              ),
              const SizedBox(height: 10),
              Text('Rs. ${item['price']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF7F34C3)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  static Widget _summaryRow(String label, String value, {bool isBold = false, double fontSize = 14, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize)),
          Text(value, style: TextStyle(color: color ?? Colors.white, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize)),
        ],
      ),
    );
  }

  Widget _addressCard({required String title, required String name, required String email, required String phone, required String address}) {
    // 'title' intentionally not shown to avoid faded duplicate line per spec
    return SizedBox(
      width: 343,
      height: 135,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Primary name in solid white
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // Email and phone in same solid white, smaller size
            Text(
              email,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              phone,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Address block in the same white, allow wrap
            Text(
              address,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
