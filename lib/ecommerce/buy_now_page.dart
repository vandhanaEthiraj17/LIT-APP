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
            // 🔹 AppDrawer (Hamburger)
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: const Icon(Icons.menu, color: Colors.white),
              ),
            ),

            // 🔹 Center Logo
            Image.asset(
              'assets/images/logo.png', // Replace with your actual logo path
              height: 41,
            ),

            // 🔹 Wishlist Icon
            GestureDetector(
              onTap: () {
                // Navigate to wishlist or handle tap
              },
              child: const Icon(Icons.favorite_border, color: Colors.white),
            ),
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
                  // 🔙 Back Button below the nav bar
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
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
                  ),

                  const SizedBox(height: 20), // Add spacing before the card

                  Container(
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
                        color: Color(0xB89333EA),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16),

                      // 🔹 Updated Box Shadow
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xB89333EA),     // Slightly more opaque purple
                          offset: Offset(0, 0),         // Centered
                          blurRadius: 4,               // Bigger blur for softness
                          spreadRadius: 1,              // Expands shadow outward more
                        ),
                      ],

                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            item['image'],
                            width: 100,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // 🔹 Item Details Column
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
                              const SizedBox(height: 4),
                              Text(item['title'],
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 15,
                                  )),
                              const SizedBox(height: 10),

                              // 🔹 Dropdowns
                              Row(
                                children: [
                                  _styledDropdown(
                                      value: 'Size: M',
                                      items: ['Size: M', 'Size: L'],
                                      onChanged: (_) {}),
                                  const SizedBox(width: 10),
                                  _styledDropdown(
                                      value: 'Qty: 1',
                                      items: ['Qty: 1', 'Qty: 2'],
                                      onChanged: (_) {}),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // 🔹 Price Row
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Row with Price and Discount aligned left and right
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Rs. ${item['price']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (item['discount'] != null)
                                        Text(
                                          '${item['discount']}',
                                          style: const TextStyle(
                                            color: Color(0xFF9333EA),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                    ],
                                  ),

                                  const SizedBox(height: 4),

                                  // Original Price aligned below
                                  if (item['original'] != null)
                                    Text(
                                      'Rs. ${item['original']}',
                                      style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // 🔹 Remove Button - aligned bottom right
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
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // 🔹 Coupon Icon
                            Image.asset(
                              'assets/images/coupon_icon.png', // Make sure this icon matches the % ticket shape in UI
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
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),

                        // 🔹 Select
                        const Text(
                          'Select',
                          style: TextStyle(
                            color: Color(0xFF7F34C3),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(color: Colors.white),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Order Summary',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Return & Exchange Policy',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Return and Exchange will be available for 7 days from the date of order of delivery',
                    style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        height: 1.4),
                  ),
                  const SizedBox(height: 100), // to avoid overlap with nav bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          // Handle tab switch if needed
        },
        isMarketplace: true,
      ),
      bottomSheet: Container(
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
            top: BorderSide(color: Color(0xFF864AFE)),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Amount\nRs. 3,199',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            Container(
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
                    color: Color(0x66000000),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  // TODO: Handle Buy Now action
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        border: Border.all(color: Color.fromRGBO(147, 51, 234, 0.4)),
      ),
      child: DropdownButton<String>(
        value: value,
        dropdownColor: Colors.black87,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
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
