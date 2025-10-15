import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lit/widgets/notification_bell.dart';
import 'package:lit/widgets/app_drawer.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  String selectedAddress = "2118 Thornridge";
  Map<String, String> addresses = {
    "2118 Thornridge":
        "2118 Thornridge Cir.\nSyracuse, Connecticut\n35624\n(209) 555-0104",
    "Headoffice":
        "2715 Ash Dr. San Jose,\nSouth Dakota\n83475\n(704) 555-0127",
  };

  void _deleteAddress(String key) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Delete Address",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          "Are you sure you want to delete this address?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete",
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        addresses.remove(key);
        if (selectedAddress == key && addresses.isNotEmpty) {
          selectedAddress = addresses.keys.first;
        }
      });
    }
  }

  void _addNewAddress() {
    String newKey = "New Address ${addresses.length + 1}";
    setState(() {
      addresses[newKey] = "Enter your new address here";
      selectedAddress = newKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu,
                                color: Colors.white, size: 24), // smaller
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        const Spacer(),
                        Image.asset("assets/images/logo.png", height: 40), // smaller
                        const Spacer(),
                        const NotificationBell(size: 28),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Back Button
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20, // smaller
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Back",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16, // smaller
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Stepper
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        _stepCircle("assets/images/maps.png", "Step 1", "Address", true),
                        const SizedBox(width: 32),
                        _stepCircle("assets/images/box.png", "Step 2", "Shipping", false),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Select Address",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Address Cards
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(left: 20),
                      children: [
                        ...addresses.keys.map((key) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: EditableAddressCard(
                              keyName: key,
                              tag: key == "2118 Thornridge" ? "HOME" : "OFFICE",
                              address: addresses[key]!,
                              isSelected: selectedAddress == key,
                              onSelect: (val) =>
                                  setState(() => selectedAddress = val),
                              onSave: (updatedText) {
                                setState(() {
                                  addresses[key] = updatedText;
                                });
                              },
                              onDelete: () => _deleteAddress(key),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 12),
                        // Add New Address Button
                        GestureDetector(
                          onTap: _addNewAddress,
                          child: Container(
                            width: 340,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.2), width: 1),
                            ),
                            child: const Center(
                              child: Text(
                                "+ Add New Address",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Back button
                        SizedBox(
                          width: 158.5,
                          height: 60,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Color(0x4D9333EA), width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Back",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Next button
                        SizedBox(
                          width: 158.5,
                          height: 60,
                          child: GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/ecommerce/payment_page'),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const RadialGradient(
                                  center: Alignment(0.08, 0.08),
                                  radius: 8,
                                  colors: [
                                    Color.fromRGBO(0, 0, 0, 0.8),
                                    Color.fromRGBO(147, 51, 234, 0.4),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
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

  Widget _stepCircle(String icon, String label1, String label2, bool active) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0x1AFFFFFF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(icon, width: 18, height: 18, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label1,
                style: TextStyle(
                    color: active ? Colors.white : Colors.white54,
                    fontSize: 14)),
            Text(label2,
                style: TextStyle(
                    color: active ? Colors.white : Colors.white54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}

class EditableAddressCard extends StatefulWidget {
  final String keyName;
  final String tag;
  final String address;
  final bool isSelected;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onSave;
  final VoidCallback onDelete;

  const EditableAddressCard({
    super.key,
    required this.keyName,
    required this.tag,
    required this.address,
    required this.isSelected,
    required this.onSelect,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditableAddressCard> createState() => _EditableAddressCardState();
}

class _EditableAddressCardState extends State<EditableAddressCard> {
  late TextEditingController _controller;
  bool isEditing = false;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleEdit() {
    setState(() {
      if (isEditing) {
        widget.onSave(_controller.text.trim());
        isSaved = true;
      } else {
        isSaved = false;
      }
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row
          Row(
            children: [
              Radio<String>(
                value: widget.keyName,
                groupValue: widget.isSelected ? widget.keyName : null,
                onChanged: (_) => widget.onSelect(widget.keyName),
                activeColor: Colors.white,
              ),
              Text(
                widget.keyName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0x1AFFFFFF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(widget.tag,
                    style: const TextStyle(color: Colors.white, fontSize: 13)),
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: toggleEdit,
                    child: Icon(
                        isEditing
                            ? Icons.check // tick after saving
                            : Icons.edit,
                        color: Colors.white,
                        size: 20),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: widget.onDelete,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white24,
                      ),
                      child: const Center(
                        child: Text(
                          "X",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Address text / edit field
          isEditing
              ? TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  maxLines: null,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                )
              : Text(widget.address,
                  style: const TextStyle(color: Colors.white70, fontSize: 15)),
        ],
      ),
    );
  }
}
