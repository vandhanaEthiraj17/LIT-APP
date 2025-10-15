import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lit/payment/payment_gateway_page.dart';
import 'package:lit/widgets/notification_bell.dart';
import 'package:lit/widgets/app_drawer.dart';

class AddressPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const AddressPage({super.key, required this.cartItems});

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
  // Track tag per address
  Map<String, String> addressTags = {
    "2118 Thornridge": "HOME",
    "Headoffice": "OFFICE",
  };

  void _deleteAddress(String key) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.1),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Delete Address",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to delete this address?",
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel",
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete",
                  style: TextStyle(color: Colors.redAccent, fontSize: 14)),
            ),
          ],
        ),
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
    // Use a unique key internally, but display will show just 'New Address'
    String newKey = "New Address ${addresses.length + 1}";
    setState(() {
      addresses[newKey] = "Enter your new address here";
      selectedAddress = newKey;
      addressTags[newKey] = "HOME";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background with blur
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 160),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar Section
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu,
                                color: Colors.white, size: 24),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        const Spacer(),
                        Image.asset("assets/images/logo.png", height: 40),
                        const Spacer(),
                        const NotificationBell(),
                      ],
                    ),
                  ),
                  // Back Button
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 6),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text("Back",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stepper
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        _stepCircle("assets/images/maps.png", "Step 1",
                            "Address", true),
                        const SizedBox(width: 64),
                        _stepCircle("assets/images/box.png", "Step 2",
                            "Shipping", false),
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Address Cards and actions (scrollable)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      children: [
                        ...addresses.keys.map((key) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 340,
                                child: EditableAddressCard(
                                  keyName: key,
                                  tag: addressTags[key] ?? "HOME",
                                  address: addresses[key]!,
                                  isSelected: selectedAddress == key,
                                  onSelect: (val) => setState(() => selectedAddress = val),
                                  onUpdate: (newKey, newAddress, newTag) {
                                    setState(() {
                                      if (newKey != key) {
                                        final wasSelected = selectedAddress == key;
                                        final existingTag = addressTags[key] ?? newTag;
                                        final value = addresses[key];
                                        if (value != null) {
                                          addresses.remove(key);
                                          addressTags.remove(key);
                                          addresses[newKey] = newAddress;
                                          addressTags[newKey] = newTag.isNotEmpty ? newTag : existingTag;
                                          if (wasSelected) selectedAddress = newKey;
                                        }
                                      } else {
                                        addresses[key] = newAddress;
                                        addressTags[key] = newTag;
                                      }
                                    });
                                  },
                                  onDelete: () => _deleteAddress(key),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 12),
                        // Add New Address Button
                        GestureDetector(
                          onTap: _addNewAddress,
                          child: const AddNewAddressButton(),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 158.5,
                height: 60,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0x4D9333EA), width: 1),
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
                        fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 158.5,
                height: 60,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentGatewayPage(
                        cartItems: widget.cartItems,
                      ),
                    ),
                  ),
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

// --------------------------- Top-Level Widgets ---------------------------

class EditableAddressCard extends StatefulWidget {
  final String keyName;
  final String tag;
  final String address;
  final bool isSelected;
  final ValueChanged<String> onSelect;
  final void Function(String newKey, String newAddress, String newTag) onUpdate;
  final VoidCallback onDelete;

  const EditableAddressCard({
    super.key,
    required this.keyName,
    required this.tag,
    required this.address,
    required this.isSelected,
    required this.onSelect,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<EditableAddressCard> createState() => _EditableAddressCardState();
}

class _EditableAddressCardState extends State<EditableAddressCard> {
  late TextEditingController _titleController;
  late TextEditingController _addressController;
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    // For entries like 'New Address 3', show simplified title while keeping unique internal key
    final initialTitle = widget.keyName.startsWith('New Address') ? 'New Address' : widget.keyName;
    _titleController = TextEditingController(text: initialTitle);
    _addressController = TextEditingController(text: widget.address);
  }

  void toggleEdit() {
    setState(() {
      if (isEditing) {
        FocusScope.of(context).unfocus();
        widget.onUpdate(
          _titleController.text.trim().isEmpty ? widget.keyName : _titleController.text.trim(),
          _addressController.text.trim(),
          widget.tag,
        );
      }
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<String>(
            value: widget.keyName,
            groupValue: widget.isSelected ? widget.keyName : null,
            onChanged: (_) => widget.onSelect(widget.keyName),
            activeColor: Colors.white,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (isEditing) {
                            _titleFocus.requestFocus();
                          }
                        },
                        child: isEditing
                            ? TextField(
                                controller: _titleController,
                                focusNode: _titleFocus,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                ),
                              )
                            : Text(
                                // Display simplified label for any 'New Address N'
                                widget.keyName.startsWith('New Address') ? 'New Address' : widget.keyName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      tooltip: 'Change tag',
                      onSelected: (val) {
                        widget.onUpdate(
                          _titleController.text.trim().isEmpty
                              ? widget.keyName
                              : _titleController.text.trim(),
                          _addressController.text.trim(),
                          val,
                        );
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'HOME', child: Text('Home')),
                        PopupMenuItem(value: 'OFFICE', child: Text('Office')),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.tag.toUpperCase() == 'HOME'
                              ? const Color(0x339333EA)
                              : const Color(0x1AFFFFFF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          widget.tag.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                isEditing
                    ? TextField(
                        controller: _addressController,
                        focusNode: _addressFocus,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.2))),
                        ),
                        maxLines: null,
                      )
                    : Text(
                        widget.address,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 15),
                      ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: IconButton(
                  tooltip: isEditing ? 'Save' : 'Edit',
                  iconSize: 20,
                  onPressed: toggleEdit,
                  icon: Icon(
                    isEditing ? Icons.check : Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: IconButton(
                  tooltip: 'Delete',
                  iconSize: 20,
                  onPressed: widget.onDelete,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddNewAddressButton extends StatelessWidget {
  const AddNewAddressButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 0.5,
                width: double.infinity,
                child: CustomPaint(
                  painter: _DashedLinePainter(color: Colors.white54),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.add, color: Colors.black, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Add New Address",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    const double dashWidth = 4.0;
    const double dashSpace = 3.0;
    double startX = 0.0;
    while (startX < size.width) {
      double endX = startX + dashWidth;
      if (endX > size.width) endX = size.width;
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(endX, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


