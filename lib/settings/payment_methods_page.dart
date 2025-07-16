import 'package:flutter/material.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/notification_bell.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  int currentIndex = -1;
  String _selectedMethod = 'Visa **** 1234';
  bool _didLoadInitialMethod = false;


  final List<String> _paymentMethods = [
    'Visa **** 1234',
    'Mastercard **** 5678',
    'UPI: yourname@bank',
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
    if (!_didLoadInitialMethod) {
      final passedMethod = ModalRoute.of(context)?.settings.arguments;
      if (passedMethod is String) {
        _selectedMethod = passedMethod;
      }
      _didLoadInitialMethod = true;
    }


    return Scaffold(
      drawer: const AppDrawer(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: _onNavTapped,
        isMarketplace: false,
      ),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 0),
            child: NotificationBell(),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 🔹 Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 🔹 Overlay
          Container(color: Colors.black.withOpacity(0.65)),

          // 🔹 Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  // 🔹 Title Centered
                  Center(
                    child: Text(
                      "PAYMENT METHODS",
                      style: GoogleFonts.kronaOne(
                        color: Colors.white,
                        fontSize: 18,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Back Button Below Title
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, _selectedMethod); // 👈 Return selected method
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text("Back", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 🔹 Subtitle
                  const Text(
                    "Your Saved Payment Methods",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // 🔹 Payment Method List
                  ..._paymentMethods.map((method) {
                    return RadioListTile<String>(
                      value: method,
                      groupValue: _selectedMethod,
                      onChanged: (value) {
                        setState(() => _selectedMethod = value!);
                      },
                      title: Text(
                        method,
                        style: const TextStyle(color: Colors.white),
                      ),
                      activeColor: const Color.fromRGBO(147, 51, 234, 0.4),
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),

                  const SizedBox(height: 40),

                  // 🔹 Add Payment Method Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        center: Alignment(0.08, 0.08),
                        radius: 9.98,
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.8),
                          Color.fromRGBO(147, 51, 234, 0.4),
                        ],
                        stops: [0.0, 0.5],
                      ),
                      border: Border.all(
                        color: Color(0xFFAEAEAE),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66000000),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: TextButton.icon(
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Add Payment Method",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/payment-gateway');
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
