import 'dart:ui';
import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String? addressTitle;
  final String? addressText;
  const OrderConfirmationPage({super.key, this.cartItems = const [], this.addressTitle, this.addressText});

  double get totalAmount {
    double total = 0;
    for (final item in cartItems) {
      final price = (item['price'] ?? 0).toString().replaceAll(RegExp(r'[^0-9.]'), '');
      final qty = (item['quantity'] ?? 1) as num;
      final p = double.tryParse(price) ?? 0;
      total += p * qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Confirm Order', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Order Summary',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (addressTitle != null || addressText != null) ...[
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, color: Colors.white70, size: 20),
                                const SizedBox(width: 8),
                                Text(addressTitle ?? 'Delivery Address', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              addressText ?? 'No address selected',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const Divider(height: 24, color: Colors.white24),
                          ],
                          const Text('Items', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Expanded(
                            child: cartItems.isEmpty
                                ? const Center(
                                    child: Text('No items in cart', style: TextStyle(color: Colors.white70)),
                                  )
                                : ListView.separated(
                                    itemCount: cartItems.length,
                                    separatorBuilder: (_, __) => const Divider(color: Colors.white12),
                                    itemBuilder: (context, index) {
                                      final item = cartItems[index];
                                      final title = (item['title'] ?? item['name'] ?? 'Item').toString();
                                      final qty = (item['quantity'] ?? 1) as num;
                                      final price = (item['price'] ?? 0).toString();
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '$title x$qty',
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          Text(price.toString(), style: const TextStyle(color: Colors.white70)),
                                        ],
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Expanded(
                                child: Text('Total', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                              Text('₹${totalAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0x4D9333EA), width: 1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Back', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const RadialGradient(
                              center: Alignment(0.08, 0.08),
                              radius: 9.98,
                              colors: [
                                Color.fromRGBO(0, 0, 0, 0.8),
                                Color.fromRGBO(147, 51, 234, 0.4),
                              ],
                              stops: [0.0, 0.6],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFAEAEAE), width: 1),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/payment/success');
                            },
                            child: const Text('Place Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
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
