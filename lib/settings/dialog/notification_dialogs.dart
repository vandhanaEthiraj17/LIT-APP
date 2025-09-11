import 'package:flutter/material.dart';
import 'dart:ui';

// ====================== EMAIL DIALOG ======================
void showEmailDialog({
  required BuildContext context,
  required Set<String> selectedEmails,
  required List<String> emailOptions,
  required Function(Set<String>) onSave,
}) {
  Set<String> tempSelection = Set.from(selectedEmails);
  showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return _glassDialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Email Notification",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...emailOptions.map((option) {
                  return CheckboxListTile(
                    value: tempSelection.contains(option),
                    title: Text(option, style: const TextStyle(color: Colors.white)),
                    checkColor: Colors.black,
                    activeColor: const Color.fromRGBO(147, 51, 234, 0.4),
                    onChanged: (bool? val) {
                      setStateDialog(() {
                        if (val == true) {
                          tempSelection.add(option);
                        } else {
                          tempSelection.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
                const SizedBox(height: 10),
                _dialogActions(
                  context: context,
                  onSave: () {
                    onSave(tempSelection);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// ====================== PUSH TOGGLE DIALOG ======================
void showPushToggleDialog({
  required BuildContext context,
  required bool currentState,
  required Function(bool) onSave,
}) {
  bool temp = currentState;
  showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return _glassDialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Push Notifications",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Enable", style: TextStyle(color: Colors.white)),
                    Switch(
                      value: temp,
                      activeColor: const Color.fromRGBO(147, 51, 234, 0.4),
                      onChanged: (val) {
                        setStateDialog(() => temp = val);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _dialogActions(
                  context: context,
                  onSave: () {
                    onSave(temp);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        },
      );
    },
  );
}

// ====================== SMS DROPDOWN DIALOG ======================
void showSMSDropdownDialog({
  required BuildContext context,
  required String currentSelection,
  required Function(String) onSelected,
}) {
  showDialog(
    context: context,
    builder: (_) {
      return _glassDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("SMS Alerts",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: currentSelection,
              isExpanded: true,
              dropdownColor: Colors.grey[900],
              iconEnabledColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              underline: Container(height: 1, color: Colors.white),
              onChanged: (val) {
                if (val != null) {
                  onSelected(val);
                  Navigator.pop(context);
                }
              },
              items: ["Instant", "Daily Summary", "Weekly Digest"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// ====================== NEW SETTINGS DIALOG ======================
void showSettingsDialog({
  required BuildContext context,
  double initialMasterVolume = 0.7,
  double initialSfxVolume = 0.9,
  required Function(double, double) onSave,
}) {
  double masterVolume = initialMasterVolume;
  double sfxVolume = initialSfxVolume;

  showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return _glassDialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("SETTINGS",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2)),
                const SizedBox(height: 20),

                // Master Volume
                _buildSlider("Master Volume", masterVolume, (val) {
                  setStateDialog(() => masterVolume = val);
                }),

                const SizedBox(height: 10),

                // SFX Volume
                _buildSlider("SFX Volume", sfxVolume, (val) {
                  setStateDialog(() => sfxVolume = val);
                }),

                const SizedBox(height: 20),

                // Music & Sound Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _circleButton(Icons.music_note),
                    const SizedBox(width: 20),
                    _circleButton(Icons.volume_up),
                  ],
                ),

                const SizedBox(height: 20),

                // Menu Buttons
                _menuButton(Icons.help_outline, "How to Play"),
                _menuButton(Icons.privacy_tip, "Privacy"),
                _menuButton(Icons.article, "Terms of Service"),
                _menuButton(Icons.support_agent, "Help And Support"),

                const SizedBox(height: 10),

                _dialogActions(
                  context: context,
                  onSave: () {
                    onSave(masterVolume, sfxVolume);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        },
      );
    },
  );
}

// ====================== COMMON HELPERS ======================

Widget _glassDialog({required Widget child}) {
  return Dialog(
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    ),
  );
}

Widget _dialogActions({required BuildContext context, required VoidCallback onSave}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
      ),
      const SizedBox(width: 10),
      GestureDetector(
        onTap: onSave,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ],
  );
}

Widget _buildSlider(String title, double value, ValueChanged<double> onChanged) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ),
      Expanded(
        flex: 3,
        child: Slider(
          value: value,
          max: 1,
          min: 0,
          divisions: 100,
          activeColor: Colors.white,
          inactiveColor: Colors.grey,
          onChanged: onChanged,
        ),
      ),
      SizedBox(
        width: 40,
        child: Text("${(value * 100).round()}%", style: const TextStyle(color: Colors.white)),
      ),
    ],
  );
}

Widget _circleButton(IconData icon) {
  return CircleAvatar(
    radius: 28,
    backgroundColor: Colors.white.withOpacity(0.2),
    child: Icon(icon, color: Colors.white, size: 30),
  );
}

Widget _menuButton(IconData icon, String label) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    width: double.infinity,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        // TODO: Implement navigation or actions
      },
      icon: Icon(icon),
      label: Text(label),
    ),
  );
}
