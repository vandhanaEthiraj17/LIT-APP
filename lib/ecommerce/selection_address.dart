import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';
import '../widgets/notification_bell.dart';

class ShippingAddressPage extends StatefulWidget {
  const ShippingAddressPage({super.key});

  @override
  State<ShippingAddressPage> createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  int _selectedAddress = 0;
  int? _editingIndex; // tracks which index is in edit mode
  bool _isAddingNew = false; // tracks if add form is open

  final _formKeys = <int, GlobalKey<FormState>>{};
  final _newAddressFormKey = GlobalKey<FormState>();

  final Map<int, Map<String, TextEditingController>> _controllers = {};
  final Map<String, TextEditingController> _newControllers = {
    'title': TextEditingController(),
    'tag': TextEditingController(),
    'details': TextEditingController(),
    'phone': TextEditingController(),
  };

  final List<Map<String, String>> _addresses = [
    {
      'title': '2118 Thornridge',
      'tag': 'HOME',
      'details': '2118 Thornridge Cir. Syracuse, Connecticut 35624',
      'phone': '(209) 555-0104',
    },
    {
      'title': 'Headoffice',
      'tag': 'OFFICE',
      'details': '2715 Ash Dr. San Jose, South Dakota 83475',
      'phone': '(704) 555-0127',
    },
  ];

  void _deleteAddress(int index) {
    setState(() {
      if (_selectedAddress == index) {
        _selectedAddress = 0;
      } else if (_selectedAddress > index) {
        _selectedAddress -= 1;
      }
      _addresses.removeAt(index);
      _controllers.remove(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: Image.asset('assets/images/logo.png', height: 40)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: NotificationBell(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: -1,
        onTap: (index) {},
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
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Select Address",
                      style: GoogleFonts.kronaOne(
                        fontSize: 18,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text("Back", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _addresses.length,
                      itemBuilder: (context, index) {
                        final address = _addresses[index];
                        final isEditing = _editingIndex == index;

                        _formKeys[index] ??= GlobalKey<FormState>();
                        _controllers[index] = {
                          'title': TextEditingController(text: address['title']),
                          'tag': TextEditingController(text: address['tag']),
                          'details': TextEditingController(text: address['details']),
                          'phone': TextEditingController(text: address['phone']),
                        };


                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: isEditing
                              ? Form(
                                  key: _formKeys[index],
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildValidatedField(
                                        "Title",
                                        _controllers[index]!['title']!,
                                      ),
                                      const SizedBox(height: 8),
                                      _buildValidatedField(
                                        "Tag",
                                        _controllers[index]!['tag']!,
                                      ),
                                      const SizedBox(height: 8),
                                      _buildValidatedField(
                                        "Details",
                                        _controllers[index]!['details']!,
                                      ),
                                      const SizedBox(height: 8),
                                      _buildValidatedField(
                                        "Phone",
                                        _controllers[index]!['phone']!,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () => setState(
                                              () => _editingIndex = null,
                                            ),
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Colors.white54,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (_formKeys[index]!
                                                  .currentState!
                                                  .validate()) {
                                                setState(() {
                                                  _addresses[index] = {
                                                    'title':
                                                        _controllers[index]!['title']!
                                                            .text,
                                                    'tag':
                                                        _controllers[index]!['tag']!
                                                            .text,
                                                    'details':
                                                        _controllers[index]!['details']!
                                                            .text,
                                                    'phone':
                                                        _controllers[index]!['phone']!
                                                            .text,
                                                  };
                                                  _editingIndex = null;
                                                });
                                              }
                                            },
                                            child: const Text(
                                              "Save",
                                              style: TextStyle(
                                                color: Color.fromRGBO(147, 51, 234, 0.4),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Radio<int>(
                                          value: index,
                                          groupValue: _selectedAddress,
                                          onChanged: (val) => setState(
                                            () => _selectedAddress = val!,
                                          ),
                                          activeColor: Colors.white,
                                          fillColor: MaterialStateProperty.all(
                                            Colors.white,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            address['title']!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            address['tag']!,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            address['details']!,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.white70,
                                                size: 18,
                                              ),
                                              onPressed: () => setState(
                                                () => _editingIndex = index,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.white70,
                                                size: 18,
                                              ),
                                              onPressed: () =>
                                                  _deleteAddress(index),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      address['phone']!,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                        );
                      },
                    ),
                  ),
                  if (_isAddingNew) ...[
                    const SizedBox(height: 12),
                    Form(
                      key: _newAddressFormKey,
                      child: Column(
                        children: [
                          _buildValidatedField(
                            "Title",
                            _newControllers['title']!,
                          ),
                          const SizedBox(height: 8),
                          _buildValidatedField("Tag", _newControllers['tag']!),
                          const SizedBox(height: 8),
                          _buildValidatedField(
                            "Details",
                            _newControllers['details']!,
                          ),
                          const SizedBox(height: 8),
                          _buildValidatedField(
                            "Phone",
                            _newControllers['phone']!,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    setState(() => _isAddingNew = false),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_newAddressFormKey.currentState!
                                      .validate()) {
                                    setState(() {
                                      _addresses.add({
                                        'title': _newControllers['title']!.text,
                                        'tag': _newControllers['tag']!.text,
                                        'details':
                                            _newControllers['details']!.text,
                                        'phone': _newControllers['phone']!.text,
                                      });
                                      _newControllers.forEach(
                                        (_, controller) => controller.clear(),
                                      );
                                      _isAddingNew = false;
                                    });
                                  }
                                },
                                child: const Text(
                                  "Add",
                                  style: TextStyle(color: Color.fromRGBO(147, 51, 234, 0.4),),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () => setState(() => _isAddingNew = !_isAddingNew),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return CustomPaint(
                                  size: Size(constraints.maxWidth, 1),
                                  painter: DashedLinePainter(),
                                );
                              },
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Add New Address",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidatedField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(147, 51, 234, 0.4),
            width: 1
          ),
        ),
        errorStyle: const TextStyle(color: Colors.red), // 🔴 Red error text
        errorBorder: const OutlineInputBorder(          // 🔴 Red border on error
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(   // 🔴 Red border on focus
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }

        if (label.toLowerCase() == 'phone') {
          final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
          if (cleaned.length < 10) {
            return 'Enter a valid phone number';
          }
        }

        return null;
      },
    );
  }



}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 5.0;
    const dashSpace = 5.0;
    final paint = Paint()
      ..color = Colors.white38
      ..strokeWidth = 1;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
