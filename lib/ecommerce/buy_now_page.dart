import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart'; // Contains CustomBottomNavBar

class BuyNowPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const BuyNowPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: const Icon(Icons.menu, color: Colors.white),
              ),
            ),
            Image.asset(
              'assets/images/logo.png',
              height: 41,
            ),
            const Icon(Icons.favorite_border, color: Colors.white),
          ],
        ),
      ),

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
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white, size: 22),
                        SizedBox(width: 4),
                        Text('Back', style: TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Product Card (matches Figma)
                  Container(
                    width: double.infinity,
                    height: 189,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        center: Alignment(0.08, 0.08),
                        radius: 13.98,
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.8),
                          Color.fromRGBO(147, 51, 234, 0.4),
                        ],
                        stops: [0.0, 0.5],
                      ),
                      border: Border.all(
                        color: Color(0xFF9333EA),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x884E4AFE),
                          offset: Offset(0, 0),
                          blurRadius: 5.5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            item['image'],
                            width: 110,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Right Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['brand'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                              const SizedBox(height: 2),
                              Text(item['title'],
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14,
                                  )),
                              const SizedBox(height: 10),

                              // Size & Qty dropdowns
                              Row(
                                children: [
                                  _styledDropdown(
                                    value: 'Size: M',
                                    items: ['Size: M', 'Size: L', 'Size: XL'],
                                    onChanged: (_) {},
                                  ),
                                  const SizedBox(width: 10),
                                  _styledDropdown(
                                    value: 'Qty: 1',
                                    items: ['Qty: 1', 'Qty: 2', 'Qty: 3'],
                                    onChanged: (_) {},
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Price + Discount
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Rs. ${item['price']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (item['discount'] != null)
                                    Text(
                                      '${item['discount']}',
                                      style: const TextStyle(
                                        color: Color(0xFF9333EA),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                ],
                              ),
                              if (item['original'] != null)
                                Text(
                                  'Rs. ${item['original']}',
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              const Spacer(),

                              // Remove Button
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                                    backgroundColor: Colors.white.withOpacity(0.08),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text('Remove',
                                      style: TextStyle(color: Colors.white, fontSize: 13)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),
                  const Divider(color: Colors.white),

                  // Apply Coupon Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/coupon_icon.png',
                            width: 24,
                            height: 24,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Apply Coupon',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      const Text(
                        'Select',
                        style: TextStyle(
                            color: Color(0xFF7F34C3),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),

                  const Divider(color: Colors.white),
                  const SizedBox(height: 10),

                  const Text(
                    'Order Summary',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  _summaryRow('Cart Total', 'Rs. 1499'),
                  _summaryRow('Savings', '-Rs. 900', color: Color(0xFF7F34C3)),
                  _summaryRow('Platform Fee', 'Free'),
                  _summaryRow('Delivery Fee', 'Free'),
                  const Divider(color: Colors.white),
                  _summaryRow('Total Amount', 'Rs. 3,199',
                      isBold: true, fontSize: 18),
                  const Divider(color: Colors.white),
                  const SizedBox(height: 24),

                  const Text(
                    'Return & Exchange Policy',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Return and Exchange will be available for 7 days from the date of order of delivery',
                    style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        height: 1.4),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {},
        isMarketplace: true,
      ),

      // Bottom Buy Now bar
      bottomSheet: Container(
        width: double.infinity,
        height: 74,
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
          border: Border(
            top: BorderSide(color: Color(0xFF864AFE), width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Rs. 3,199',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Container(
              width: 110,
              height: 40,
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
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x884E4AFE),
                    offset: Offset(0, 0),
                    blurRadius: 5.5,
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  // TODO: Handle Buy Now
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Buy Now',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Styled Dropdown (button-like)
  Widget _styledDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: DropdownButton<String>(
        value: value,
        dropdownColor: Colors.black87,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
        style: const TextStyle(color: Colors.white, fontSize: 12),
        isExpanded: false,
        onChanged: onChanged,
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(color: Colors.white)),
                ))
            .toList(),
      ),
    );
  }

  // 🔹 Order Summary Row
  static Widget _summaryRow(String label, String value,
      {bool isBold = false, double fontSize = 14, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: fontSize)),
          Text(value,
              style: TextStyle(
                  color: color ?? Colors.white,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: fontSize)),
        ],
      ),
    );
  }
}
