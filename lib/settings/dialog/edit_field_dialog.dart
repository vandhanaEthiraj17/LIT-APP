import 'dart:ui';
import 'package:flutter/material.dart';

class EditFieldDialog extends StatefulWidget {
  final String fieldLabel;
  final String initialValue;
  final void Function(String) onFieldSaved;

  const EditFieldDialog({
    super.key,
    required this.fieldLabel,
    required this.initialValue,
    required this.onFieldSaved,
  });

  @override
  State<EditFieldDialog> createState() => _EditFieldDialogState();
}

class _EditFieldDialogState extends State<EditFieldDialog> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue.trim().isEmpty) {
      _controller = TextEditingController(text: '');
    } else if (widget.fieldLabel == "Phone") {
      final stripped = widget.initialValue.replaceAll("+91", "").trim();
      _controller = TextEditingController(text: stripped);
    } else {
      _controller = TextEditingController(text: widget.initialValue);
    }
  }

  String? get _description {
    if (widget.fieldLabel == "Name") {
      return "Help people discover your account by using the name you're known by: either your full name, nickname, or business name.\nYou can only change your name twice within 14 days.";
    }
    if (widget.fieldLabel == "Phone") {
      return "Enter a 10-digit phone number. A country code (+91) will be added automatically.";
    }
    if (widget.fieldLabel == "Email") {
      return "Enter a valid email address. This will be used to secure your account and receive notifications.";
    }
    return null;
  }

  void _validateAndSubmit() {
    final newText = _controller.text.trim();

    if (widget.fieldLabel == "Name") {
      if (newText.length < 3) {
        setState(() => _errorText = "Name must be at least 3 characters.");
        return;
      }
    }

    if (widget.fieldLabel == "Phone") {
      final phoneRegExp = RegExp(r'^[0-9]{10}$');
      if (!phoneRegExp.hasMatch(newText)) {
        setState(() => _errorText = "Please enter a valid 10-digit phone number.");
        return;
      }
      widget.onFieldSaved("+91 $newText");
      Navigator.of(context).pop();
      return;
    }

    if (widget.fieldLabel == "Email") {
      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegExp.hasMatch(newText)) {
        setState(() => _errorText = "Please enter a valid email address.");
        return;
      }
    }

    widget.onFieldSaved(newText);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
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
                      // === LABEL INSIDE INPUT CONTAINER ===
                      Container(
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
                              widget.fieldLabel,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                if (widget.fieldLabel == "Phone")
                                  const Text("+91 ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    keyboardType: widget.fieldLabel == "Phone"
                                        ? TextInputType.number
                                        : TextInputType.text,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: const InputDecoration.collapsed(hintText: ""),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_description != null)
                        Text(
                          _description!,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      if (_errorText != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _errorText!,
                          style: const TextStyle(
                              color: Colors.redAccent, fontSize: 12),
                        ),
                      ],
                      const SizedBox(height: 20),
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
}
