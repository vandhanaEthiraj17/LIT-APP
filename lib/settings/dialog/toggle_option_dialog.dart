import 'dart:ui';
import 'package:flutter/material.dart';

class ToggleOptionDialog extends StatefulWidget {
  final String title;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const ToggleOptionDialog({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<ToggleOptionDialog> createState() => _ToggleOptionDialogState();
}

class _ToggleOptionDialogState extends State<ToggleOptionDialog> {
  late bool isOn = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Off", style: TextStyle(color: Colors.white)),
                      Switch(
                        value: isOn,
                        onChanged: (val) => setState(() => isOn = val),
                        activeColor:
                        const Color.fromRGBO(147, 51, 234, 0.4), // Gradient match
                        inactiveTrackColor: Colors.white30,
                      ),
                      const Text("On", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      widget.onChanged(isOn);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
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
                      child: const Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
