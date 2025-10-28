import 'package:flutter/material.dart';
import 'package:lit/ecommerce/address_page.dart';
import 'package:lit/pages/notifications_page.dart';
import 'package:lit/widgets/app_drawer.dart';

class BuyNowPage extends StatefulWidget {
  final List<Map<String, dynamic>> buyNowItems;

  const BuyNowPage({super.key, required this.buyNowItems});

  @override
  State<BuyNowPage> createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  final List<String> availableSizes = ['XXS', 'XS', 'S', 'M', 'L', 'XL'];

  @override
  Widget build(BuildContext context) {
    final buyNowItems = widget.buyNowItems;
    final total = buyNowItems.fold<int>(
      0,
      (sum, item) => sum + (item['price'] as int? ?? 0),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AppDrawer()),
              );
            },
          ),
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('assets/images/background.png', fit: BoxFit.cover)),
          Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.6))),

          SafeArea(
            child: buyNowItems.isEmpty
                ? const Center(
                    child: Text(
                      "No items selected",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      children: [
                        const SizedBox(height: 12),
                        ...buyNowItems
                            .map((item) => _itemCard(context, item))
                            .toList(),

                        const SizedBox(height: 20),

                        // 🟣 Apply Coupon Section
                        _applyCouponUI(),

                        const SizedBox(height: 20),
                        Container(
                          height: 1,
                          color: Colors.white38,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        _orderSummary(total),
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
                              color: Colors.white54, fontSize: 12, height: 1.4),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      bottomSheet: buyNowItems.isEmpty
          ? const SizedBox.shrink()
          : _bottomBuyNow(total, buyNowItems),
    );
  }

  // 🟣 Product Card
  Widget _itemCard(BuildContext context, Map<String, dynamic> item) {
    String selectedSize = item['selectedSize'] ?? 'M';
    int selectedQty = item['selectedQty'] ?? 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color(0xFF864AFE), width: 0.8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item['image'],
              width: 85,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['brand'],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(item['title'],
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showSizeSelector(context, item),
                      child: _optionBox('Size: $selectedSize'),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => _showQtySelector(context, item),
                      child: _optionBox('Qty: $selectedQty'),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rs. ${item['price']}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(item['discount'] ?? '',
                        style: const TextStyle(
                            color: Color(0xFF9333EA),
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🟣 Apply Coupon Section (UI only)
  Widget _applyCouponUI() {
    return Column(
      children: [
        // White line above
        Container(
          height: 1,
          color: Colors.white,
        ),
        // Apply Coupon content
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
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
        ),
        // White line below
        Container(
          height: 1,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _optionBox(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  // 🟣 Order Summary
  Widget _orderSummary(int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Order Summary',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        const SizedBox(height: 8),
        _summaryRow('Cart Total', 'Rs. $total'),
        _summaryRow('Savings', '-Rs. 900', color: Color(0xFF7F34C3)),
        _summaryRow('Platform Fee', 'Free'),
        _summaryRow('Delivery Fee', 'Free'),
        const Divider(color: Colors.white),
        _summaryRow('Total Amount', 'Rs. $total',
            isBold: true, fontSize: 18),
        const Divider(color: Colors.white),
      ],
    );
  }

  Widget _summaryRow(String title, String value,
      {bool isBold = false, double fontSize = 14, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
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

  // 🟣 Bottom Buy Now Button
  Widget _bottomBuyNow(int total, List<Map<String, dynamic>> buyNowItems) {
    return Container(
      width: double.infinity,
      height: 74,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.08, 0.08),
          radius: 15.98,
          colors: [Color.fromRGBO(0, 0, 0, 0.8), Color.fromRGBO(147, 51, 234, 0.4)],
          stops: [0.0, 0.5],
        ),
        border: Border(top: BorderSide(color: Color(0xFF864AFE), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Total Amount',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
              const SizedBox(height: 4),
              Text('Rs. $total',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddressPage(cartItems: widget.buyNowItems),
                ),
              );
            },
            child: Container(
              width: 150,
              height: 40,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.08, 0.08),
                  radius: 7.98,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.8),
                    Color.fromRGBO(147, 51, 234, 0.4)
                  ],
                  stops: [0.0, 0.5],
                ),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Buy Now",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🟣 Size / Qty selection bottom sheets
  void _showSizeSelector(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        String selectedSize = item['selectedSize'] ?? 'M';
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(16),
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Select Size",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: availableSizes.map((size) {
                      bool isSelected = size == selectedSize;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setModalState(() => selectedSize = size);
                            setState(() => item['selectedSize'] = size);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 50,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF9333EA) : Colors.white,
                                width: isSelected ? 2 : 1,
                              ),
                              color: isSelected
                                  ? const Color.fromRGBO(147, 51, 234, 0.2)
                                  : Colors.transparent,
                            ),
                            child: Text(size,
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                _gradientDoneButton(context),
                const SizedBox(height: 10),
              ],
            ),
          );
        });
      },
    );
  }

  void _showQtySelector(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setModalState) {
          int selectedQty = item['selectedQty'] ?? 1;
          return Container(
            padding: const EdgeInsets.all(16),
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Select Quantity",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _qtyButton(Icons.remove, () {
                      if (selectedQty > 1) {
                        setModalState(() => selectedQty--);
                        setState(() => item['selectedQty'] = selectedQty);
                      }
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '$selectedQty',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    _qtyButton(Icons.add, () {
                      setModalState(() => selectedQty++);
                      setState(() => item['selectedQty'] = selectedQty);
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                _gradientDoneButton(context),
                const SizedBox(height: 10),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _gradientDoneButton(BuildContext context) {
    return Container(
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
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text("Done",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
