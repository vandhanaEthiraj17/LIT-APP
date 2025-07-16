import 'dart:ui';
import 'package:flutter/material.dart';

class PermissionListDialog extends StatefulWidget {
  final Map<String, bool>? initialPermissions;
  final void Function(Map<String, bool>)? onPermissionsChanged;

  const PermissionListDialog({
    super.key,
    this.initialPermissions,
    this.onPermissionsChanged,
  });

  @override
  State<PermissionListDialog> createState() => _PermissionListDialogState();
}

class _PermissionListDialogState extends State<PermissionListDialog> {
  late Map<String, bool> permissions;

  @override
  void initState() {
    super.initState();
    permissions = widget.initialPermissions ?? {
      "Location": true,
      "Camera": true,
      "Gallery": true,
    };
  }

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
                  const Text(
                    "App Permissions",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...permissions.entries.map((entry) {
                    return SwitchListTile(
                      title: Text(
                        entry.key,
                        style: const TextStyle(color: Colors.white),
                      ),
                      value: entry.value,
                      onChanged: (val) {
                        setState(() {
                          permissions[entry.key] = val;
                        });
                      },
                      activeColor: const Color.fromRGBO(147, 51, 234, 0.4),
                      inactiveTrackColor: Colors.white30,
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      widget.onPermissionsChanged?.call(permissions);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
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
                        "Save",
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
