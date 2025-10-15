import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';

import '../widgets/notification_bell.dart';

class PaymentGatewayPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  const PaymentGatewayPage({super.key, required this.cartItems});

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

  // Card form controllers
  final TextEditingController _cardNumberCtl = TextEditingController();
  final TextEditingController _cvvCtl = TextEditingController();
  final TextEditingController _validThruCtl = TextEditingController();
  final TextEditingController _fullNameCtl = TextEditingController();
  final TextEditingController _paypalCtl = TextEditingController();
  // UPI
  final TextEditingController _upiCtl = TextEditingController();
  final FocusNode _upiFocus = FocusNode();
  int? _selectedUpiIndex; // 0: gpay, 1: phonepe, 2: amazonpay
  String _upiState = 'idle'; // idle | verifying | valid | invalid
  bool _upiSave = false;

  // Card form validation states
  bool _cardError = false;
  bool _cvvError = false;
  bool _validThruError = false;
  bool _saveCard = false;
  bool _paypalError = false;
  bool _paypalSuccess = false;

  void _validateCardNumber(String v) {
    setState(() {
      final digitsOnly = v.replaceAll(RegExp(r'\D'), '');
      _cardError = digitsOnly.length != 16;
    });
  }

  Widget _buildValidatedField({
    required String label,
    required TextEditingController controller,
    required bool isError,
    required String errorText,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
    bool obscureText = false,
    String? hintText,
  }) {
    final Color labelColor = isError ? Colors.redAccent : Colors.white70;
    final Color textColor = isError ? Colors.redAccent : Colors.white;
    final Color borderColor = isError ? Colors.redAccent : Colors.white30;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: labelColor, fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
          ),
        ),
        if (isError) ...[
          const SizedBox(height: 6),
          Text(
            errorText,
            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
          ),
        ],
      ],
    );
  }

  void _validateCVV(String v) {
    setState(() {
      final digitsOnly = v.replaceAll(RegExp(r'\D'), '');
      _cvvError = digitsOnly.length != 3;
    });
  }

  void _validateValidThru(String v) {
    setState(() {
      final match = RegExp(r'^(0[1-9]|1[0-2])\/[0-9]{2}$').firstMatch(v.trim());
      _validThruError = match == null;
    });
  }

  void _resetCardErrors() {
    setState(() {
      _cardError = false;
      _cvvError = false;
      _validThruError = false;
    });
  }



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
            onTap: () {
              setState(() {
                _isCardExpanded = !_isCardExpanded;
                if (!_isCardExpanded) {
                  // Reset all field error states when collapsing
                  _resetCardErrors();
                }
              });
            },
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

            // Card Number (with validation)
            _buildValidatedField(
              label: "Card Number",
              controller: _cardNumberCtl,
              isError: _cardError,
              errorText: "Enter valid number",
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 12),

            // CVV & Valid Thru
            Row(
              children: [
                Expanded(
                  child: _buildValidatedField(
                    label: "CVV/CVC No.",
                    controller: _cvvCtl,
                    isError: _cvvError,
                    errorText: "Enter valid CVV",
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildValidatedField(
                    label: "Valid Thru",
                    controller: _validThruCtl,
                    isError: _validThruError,
                    errorText: "Enter valid date",
                    keyboardType: TextInputType.datetime,
                    hintText: "MM/YY",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Full Name (no validation styling)
            _buildValidatedField(
              label: "Full Name",
              controller: _fullNameCtl,
              isError: false,
              errorText: "",
            ),

            const SizedBox(height: 12),

            // Save card checkbox (outlined, white tick)
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _saveCard,
                      onChanged: (v) => setState(() => _saveCard = v ?? false),
                      fillColor: MaterialStateProperty.all(Colors.transparent),
                      checkColor: Colors.white,
                      side: const BorderSide(color: Colors.white70, width: 1.5),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Save card details for future use",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

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
                  onPressed: () {
                    _validateCardNumber(_cardNumberCtl.text);
                    _validateCVV(_cvvCtl.text);
                    _validateValidThru(_validThruCtl.text);
                    if (!_cardError && !_cvvError && !_validThruError) {
                      Navigator.pushNamed(context, '/payment-success', arguments: {
                        'orderId': DateTime.now().millisecondsSinceEpoch.toString(),
                      });
                    }
                  },
                  child: const Text(
                    "Send OTP",
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
              isExpanded: true,
              dropdownColor: Colors.black87,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
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
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          if (_isPaypalExpanded) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Paypal ID",
                style: TextStyle(
                  color: _paypalSuccess
                      ? Colors.greenAccent
                      : (_paypalError ? Colors.redAccent : Colors.white),
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
                      controller: _paypalCtl,
                      style: TextStyle(
                        color: _paypalSuccess
                            ? Colors.greenAccent
                            : (_paypalError ? Colors.redAccent : Colors.white),
                      ),
                      decoration: InputDecoration(
                        hintText: "Paypal ID",
                        hintStyle: const TextStyle(color: Colors.white54),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        suffixIcon: _paypalError
                            ? const Icon(Icons.error_outline, color: Colors.redAccent)
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _paypalSuccess
                                ? Colors.greenAccent
                                : (_paypalError ? Colors.redAccent : Colors.white30),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _paypalSuccess
                                ? Colors.greenAccent
                                : (_paypalError ? Colors.redAccent : Colors.white30),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _paypalSuccess
                                ? Colors.greenAccent
                                : (_paypalError ? Colors.redAccent : Colors.white30),
                            width: 1.5,
                          ),
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
                        setState(() {
                          if (_paypalError) {
                            // Retry: reset to neutral state
                            _paypalError = false;
                            _paypalSuccess = false;
                          } else {
                            // Validate on Confirm (dummy)
                            final txt = _paypalCtl.text.trim();
                            final valid = RegExp(r'^\S+@\S+$').hasMatch(txt);
                            _paypalSuccess = valid;
                            _paypalError = !valid;
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          _paypalError ? "Retry" : "Confirm",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_paypalError) ...[
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter valid ID",
                  style: TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
            ],
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
            onTap: () => setState(() {
              _isUpiExpanded = !_isUpiExpanded;
              if (!_isUpiExpanded) {
                // Reset all when collapsing
                _upiState = 'idle';
                _upiCtl.clear();
                _selectedUpiIndex = null;
                _upiSave = false;
                _upiFocus.unfocus();
              }
            }),
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSelectableUpiApp(0, "assets/images/gpay.png", 'Google Pay'),
                _buildSelectableUpiApp(1, "assets/images/paytm.png", 'Paytm'),
                _buildSelectableUpiApp(2, "assets/images/phonepe.png", 'PhonePe'),
                _buildSelectableUpiApp(3, "assets/images/amazonpay.png", 'Amazon Pay'),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter UPI ID",
                style: TextStyle(
                  color: _upiState == 'valid'
                      ? Colors.greenAccent
                      : (_upiState == 'invalid' ? Colors.redAccent : Colors.white),
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
                      controller: _upiCtl,
                      focusNode: _upiFocus,
                      enabled: _upiState != 'verifying',
                      style: TextStyle(
                        color: _upiState == 'valid'
                            ? Colors.greenAccent
                            : (_upiState == 'invalid' ? Colors.redAccent : Colors.white),
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter UPI ID",
                        hintStyle: const TextStyle(color: Colors.white54),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        // No loading spinner inside the input; only show invalid icon
                        suffixIcon: (_upiState == 'invalid'
                                ? const Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                  )
                                : null),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _upiState == 'valid'
                                ? Colors.greenAccent
                                : (_upiState == 'invalid' ? Colors.redAccent : Colors.white30),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _upiState == 'valid'
                                ? Colors.greenAccent
                                : (_upiState == 'invalid' ? Colors.redAccent : Colors.white30),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _upiState == 'valid'
                                ? Colors.greenAccent
                                : (_upiState == 'invalid' ? Colors.redAccent : Colors.white70),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
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
                      onPressed: () async {
                        if (_selectedUpiIndex == null) return; // need app selection
                        final txt = _upiCtl.text.trim();
                        if (txt.isEmpty) return; // ignore empty input
                        setState(() => _upiState = 'verifying');
                        await Future.delayed(const Duration(seconds: 2));
                        final valid = RegExp(r'^\S+@\S+$').hasMatch(txt);
                        setState(() => _upiState = valid ? 'valid' : 'invalid');
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        transitionBuilder: (c, a) => FadeTransition(opacity: a, child: c),
                        child: (_upiState == 'verifying')
                            ? Row(
                                key: const ValueKey('verifying'),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  ),
                                  SizedBox(width: 8),
                                  Text("Verifying", style: TextStyle(color: Colors.white)),
                                ],
                              )
                            : Text(
                                _upiState == 'invalid' ? 'Retry' : 'Verify',
                                key: ValueKey(_upiState),
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_upiState == 'invalid') ...[
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter valid ID",
                  style: TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _upiSave,
                    onChanged: (v) => setState(() => _upiSave = v ?? false),
                    fillColor: MaterialStateProperty.all(Colors.transparent),
                    checkColor: Colors.white,
                    side: const BorderSide(color: Colors.white70, width: 1.5),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Save details for future use",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectableUpiApp(int index, String assetPath, String tooltip) {
    final selected = _selectedUpiIndex == index;
    final double iconSize = assetPath.contains('paytm') ? 36 : 32;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () => setState(() => _selectedUpiIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? Colors.white70 : Colors.white30, width: selected ? 1.5 : 1),
          ),
          child: Center(child: Image.asset(assetPath, width: iconSize, height: iconSize)),
        ),
      ),
    );
  }


}