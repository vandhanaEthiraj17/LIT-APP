import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';

import '../widgets/notification_bell.dart';

class PaymentGatewayPage extends StatefulWidget {
  const PaymentGatewayPage({super.key});

  @override
  State<PaymentGatewayPage> createState() => _PaymentGatewayPageState();
}

class _PaymentGatewayPageState extends State<PaymentGatewayPage> {
  int currentIndex = -1;
  bool _isCardExpanded = false;
  bool _isNetBankingExpanded = false;
  bool _isPaypalExpanded = false;
  bool _isUpiExpanded = false;
  Map<String, String>? _selectedBank;

  final List<Map<String, String>> _banks = [
    {'name': 'State Bank of India', 'logo': 'assets/images/sbi.jpg'},
    {'name': 'HDFC Bank', 'logo': 'assets/images/hdfc.png'},
    {'name': 'ICICI Bank', 'logo': 'assets/images/icic.png'},
    {'name': 'Axis Bank', 'logo': 'assets/images/axis.png'},
  ];



  void _onNavTapped(int index) {
    setState(() => currentIndex = index);
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/scan');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        centerTitle: true,
        title: Image.asset('assets/images/logo.png', height: 40),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: NotificationBell(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: _onNavTapped,
        isMarketplace: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.65)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: (_isCardExpanded || _isNetBankingExpanded || _isPaypalExpanded || _isUpiExpanded)
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height - kToolbarHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        Center(
                          child: Text(
                            "PAYMENT",
                            style: GoogleFonts.kronaOne(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 6,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

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

                        const SizedBox(height: 40),

                        const Text(
                          "Select Payment Method",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),

                        const SizedBox(height: 20),

                        // 🔽 Debit/Credit Card with expansion
                        _buildCardWithExpansion(),

                        const SizedBox(height: 12),
                        _buildNetBankingCard(),

                        const SizedBox(height: 12),
                        _buildPaypalCard(),
                        const SizedBox(height: 12),
                        _buildUPICard(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWithExpansion() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _isCardExpanded = !_isCardExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.credit_card, color: Colors.white),
                    SizedBox(width: 14),
                    Text(
                      "Debit / Credit Card",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _isCardExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          if (_isCardExpanded) ...[
            const SizedBox(height: 16),

            // Card Number
            _buildTextField("Card Number"),

            const SizedBox(height: 12),

            // CVV & Valid Thru
            Row(
              children: [
                Expanded(child: _buildTextField("CVV/CVC No.")),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField("Valid Thru")),
              ],
            ),

            const SizedBox(height: 12),

            // Full Name
            _buildTextField("Full Name"),

            const SizedBox(height: 20),

            // Send OTP Button
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    center: Alignment(0.08, 0.08),
                    radius: 11.98,
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.8),
                      Color.fromRGBO(147, 51, 234, 0.4),
                    ],
                    stops: [0.0, 0.7],
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
                  onPressed: () {},
                  child: const Text(
                    "Send OTP",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Save Details

            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (val) {},
                  activeColor: Colors.purple,
                ),
                const Text(
                  "Save details for future",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }



  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white30),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white30),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildNetBankingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _isNetBankingExpanded = !_isNetBankingExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.account_balance_outlined, color: Colors.white),
                    SizedBox(width: 14),
                    Text(
                      "Net Banking",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _isNetBankingExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          if (_isNetBankingExpanded) ...[
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select Bank from the List",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Map<String, String>>(
              value: _selectedBank,
              dropdownColor: Colors.black87,
              iconEnabledColor: Colors.white,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              hint: const Text("Select Bank", style: TextStyle(color: Colors.white54)),
              items: _banks.map((bank) {
                return DropdownMenuItem<Map<String, String>>(
                  value: bank,
                  child: Row(
                    children: [
                      Image.asset(
                        bank['logo']!,
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        bank['name']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              }).toList(), // ✅ This closes `.map()` properly
              onChanged: (value) {
                setState(() {
                  _selectedBank = value;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    center: Alignment(0.08, 0.08),
                    radius: 11.98,
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.8),
                      Color.fromRGBO(147, 51, 234, 0.4),
                    ],
                    stops: [0.0, 0.7],
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
                    // Handle proceed
                  },
                  child: const Text(
                    "Proceed",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildPaypalCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _isPaypalExpanded = !_isPaypalExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.paypal, color: Colors.white),
                    SizedBox(width: 14),
                    Text(
                      "Paypal",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _isPaypalExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          if (_isPaypalExpanded) ...[
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Paypal ID",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: const TextStyle(color: Colors.white54),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  child: Container(
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
                      borderRadius: BorderRadius.circular(10),
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
                        // Handle confirm
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildUPICard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _isUpiExpanded = !_isUpiExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.currency_rupee, color: Colors.white),
                    SizedBox(width: 14),
                    Text(
                      "UPI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _isUpiExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          if (_isUpiExpanded) ...[
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Choose App",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildUpiAppIcon("assets/images/gpay.png"),
                _buildUpiAppIcon("assets/images/paytm.png"),
                _buildUpiAppIcon("assets/images/phonepe.png"),
                _buildUpiAppIcon("assets/images/amazonpay.png"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(
                  child: Divider(
                    color: Colors.white24,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Or",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.white24,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter UPI ID",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: const TextStyle(color: Colors.white54),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white30),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        center: Alignment(0.08, 0.08),
                        radius: 11.98,
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.8),
                          Color.fromRGBO(147, 51, 234, 0.4),
                        ],
                        stops: [0.0, 0.7],
                      ),
                      borderRadius: BorderRadius.circular(10),
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
                        // handle verify
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "Verify",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUpiAppIcon(String assetPath) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white30),
      ),
      child: Center(
        child: Image.asset(assetPath, width: 32, height: 32),
      ),
    );
  }


}
