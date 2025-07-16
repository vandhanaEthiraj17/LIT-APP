import 'dart:ui';
import 'package:flutter/material.dart';

class ChangePasswordDialog extends StatefulWidget {
  final Function(String oldPassword, String newPassword) onSave;

  const ChangePasswordDialog({super.key, required this.onSave});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController _oldController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  String? _errorText;

  void _validateAndSubmit() {
    final oldPwd = _oldController.text.trim();
    final newPwd = _newController.text.trim();

    if (oldPwd.isEmpty || newPwd.isEmpty) {
      setState(() => _errorText = "Both fields are required.");
      return;
    }

    if (oldPwd == newPwd) {
      setState(() => _errorText = "New password must be different.");
      return;
    }

    if (!_isValidPassword(newPwd)) {
      setState(() => _errorText =
      "Password must be at least 8 characters long,\ninclude uppercase, lowercase, number & special character.");
      return;
    }

    widget.onSave(oldPwd, newPwd);
    Navigator.of(context).pop();
  }

  bool _isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
    return regex.hasMatch(password);
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
                  padding: const EdgeInsets.fromLTRB(20, 35, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildCustomInput("Old Password", _oldController),
                      const SizedBox(height: 16),
                      _buildCustomInput("New Password", _newController),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, '/forgot_password');
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_errorText != null)
                        Text(
                          _errorText!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                        ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _validateAndSubmit,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
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
                            borderRadius: BorderRadius.circular(25),
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

  Widget _buildCustomInput(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          TextField(
            controller: controller,
            obscureText: true,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration.collapsed(hintText: ""),
          ),
        ],
      ),
    );
  }
}
