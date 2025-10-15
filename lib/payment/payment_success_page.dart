import 'dart:ui';
import 'package:flutter/material.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String? orderId;
  const PaymentSuccessPage({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Payment Success', style: TextStyle(color: Colors.white)),
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x339333EA),
                      ),
                      child: const Center(
                        child: Icon(Icons.check_circle, color: Color(0xFF9333EA), size: 76),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Payment Successful!',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      orderId == null ? 'Thank you for your purchase.' : 'Order #$orderId confirmed.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0x4D9333EA), width: 1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                            child: const Text('Continue Shopping', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                                Navigator.pushReplacementNamed(context, '/orders');
                              },
                              child: const Text('Track Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    // Local UPI Card with Verify/Verifying/Retry flow (self-contained)
                    const _UpiCardLocal(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- Local UPI Card (Self-contained) --------------------
class _UpiCardLocal extends StatefulWidget {
  const _UpiCardLocal();

  @override
  State<_UpiCardLocal> createState() => _UpiCardLocalState();
}

class _UpiCardLocalState extends State<_UpiCardLocal> {
  int? _selectedUpiIndex;
  final TextEditingController _upiCtl = TextEditingController();
  final FocusNode _upiFocus = FocusNode();
  String _upiState = 'idle'; // idle | verifying | valid | invalid

  @override
  void dispose() {
    _upiCtl.dispose();
    _upiFocus.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.currency_rupee, color: Colors.white),
                  SizedBox(width: 14),
                  Text(
                    'UPI',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSelectableUpiApp(0, 'assets/images/gpay.png', 'Google Pay'),
              _buildSelectableUpiApp(1, 'assets/images/paytm.png', 'Paytm'),
              _buildSelectableUpiApp(2, 'assets/images/phonepe.png', 'PhonePe'),
              _buildSelectableUpiApp(3, 'assets/images/amazonpay.png', 'Amazon Pay'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Enter UPI ID',
            style: TextStyle(
              color: _upiState == 'valid'
                  ? Colors.greenAccent
                  : (_upiState == 'invalid' ? Colors.redAccent : Colors.white),
              fontSize: 14,
              fontWeight: FontWeight.bold,
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
                      hintText: 'Enter UPI ID',
                      hintStyle: const TextStyle(color: Colors.white54),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      suffixIcon: (_upiState == 'invalid'
                          ? const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
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
                      if (_selectedUpiIndex == null) return;
                      final txt = _upiCtl.text.trim();
                      if (txt.isEmpty) return;
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
                                Text('Verifying', style: TextStyle(color: Colors.white)),
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
                'Enter valid ID',
                style: TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),
          ],

          // Save details checkbox (static UI to match other screens)
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text('Save details for future', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
