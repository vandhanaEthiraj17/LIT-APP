import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';
import 'package:lit/widgets/notification_bell.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String? orderId;
  const PaymentSuccessPage({super.key, this.orderId});

  void _onNavTapped(BuildContext context, int index) {
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
    final args = ModalRoute.of(context)?.settings.arguments;
    List<Map<String, dynamic>> forwardedCartItems = const [];
    String? routeOrderId;
    if (args is Map) {
      final ci = args['cartItems'];
      if (ci is List) {
        forwardedCartItems = ci.cast<Map<String, dynamic>>();
      }
      final oid = args['orderId'];
      if (oid is String) routeOrderId = oid;
    }
    final effectiveOrderId = orderId ?? routeOrderId;
    return Scaffold(
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
        onTap: (i) => _onNavTapped(context, i),
        isMarketplace: false,
      ),
      body: Stack(
        children: [
          // Full-screen background
          Positioned.fill(
            child: Image.asset('assets/images/background.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Animated SVG success icon (bright zoom in/out)
                            _PulsingSuccessIcon(),
                            const SizedBox(height: 20),
                            // PAYMENT and SUCCESSFUL on separate lines with spacing
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'PAYMENT',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.kronaOne(
                                    color: const Color(0xEB3CAF47),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                    height: 1.4,
                                    letterSpacing: 6,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'SUCCESSFUL',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.kronaOne(
                                    color: const Color(0xEB3CAF47),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                    height: 1.4,
                                    letterSpacing: 6,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Thank you!',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              effectiveOrderId == null
                                  ? 'Your order has been placed.'
                                  : 'Your order #$effectiveOrderId has been placed.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(height: 28),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 240),
                              child: SizedBox(
                                width: double.infinity,
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
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/order-confirmation',
                                        arguments: {
                                          'cartItems': forwardedCartItems,
                                        },
                                      );
                                    },
                                    child: const Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingSuccessIcon extends StatefulWidget {
  const _PulsingSuccessIcon();

  @override
  State<_PulsingSuccessIcon> createState() => _PulsingSuccessIconState();
}

class _PulsingSuccessIconState extends State<_PulsingSuccessIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.9, end: 1.12)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    // 0.0 -> 1.0 for glow intensity
    _glow = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xEB2E8F3C); // slightly darker green for glow/border
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, child) {
        final blur = 8 + 18 * _glow.value; // 8..26
        final spread = 0.0 + 2.0 * _glow.value; // 0..2
        final ringOpacity = 0.18 + 0.20 * _glow.value; // 0.18..0.38
        return ScaleTransition(
          scale: _scale,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.12),
              boxShadow: [
                BoxShadow(
                  color: green.withOpacity(0.55),
                  blurRadius: blur,
                  spreadRadius: spread,
                ),
              ],
              border: Border.all(color: green.withOpacity(ringOpacity), width: 2),
            ),
            child: Center(child: child),
          ),
        );
      },
      child: SizedBox(
        width: 36,
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: const [
            // Solid green circular background
            DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFF2E8F3C), // slightly darker circle fill
                shape: BoxShape.circle,
              ),
            ),
            // White tick mark
            Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
