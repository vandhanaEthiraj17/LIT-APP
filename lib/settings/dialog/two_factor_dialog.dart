import 'dart:ui';
import 'package:flutter/material.dart';

class TwoFactorDialog extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const TwoFactorDialog({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<TwoFactorDialog> createState() => _TwoFactorDialogState();
}

class _TwoFactorDialogState extends State<TwoFactorDialog> {
  late bool isEnabled;

  @override
  void initState() {
    super.initState();
    isEnabled = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Two-Factor Authentication",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Add extra security to your account by enabling 2FA.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const RadialGradient(
                            center: Alignment(0.08, 0.10),
                            radius: 12.98,
                            colors: [
                              Color.fromRGBO(0, 0, 0, 0.8),
                              Color.fromRGBO(147, 51, 234, 0.4),
                            ],
                            stops: [0.0, 0.7],
                          ),
                          border: Border.all(
                            color: Color(0xFFAEAEAE),
                            width: 1,
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
                        child: SwitchListTile(
                          value: isEnabled,
                          onChanged: (val) {
                            setState(() => isEnabled = val);
                          },
                          activeColor: Colors.white,
                          inactiveTrackColor: Colors.white30,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          title: Text(
                            isEnabled ? "Enabled" : "Disabled",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                    ],
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white30,
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
