import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../widgets/notification_bell.dart';

class GameCategoryPage extends StatefulWidget {
  const GameCategoryPage({super.key});

  @override
  State<GameCategoryPage> createState() => _GameCategoryPageState();
}

class _GameCategoryPageState extends State<GameCategoryPage> with TickerProviderStateMixin {
  int currentIndex = -1;
  String selectedCategory = 'Bags';
  List<String> selectedCategories = [];
  late AnimationController _controller;
  late Animation<double> _angleAnimation;

  final List<Map<String, String>> categories = [
    {'label': 'Bags', 'image': 'assets/images/bag.png'},
    {'label': 'Clothing', 'image': 'assets/images/clothing.png'},
    {'label': 'Footwear', 'image': 'assets/images/shoes.png'},
    {'label': 'Accessories', 'image': 'assets/images/accessories.png'},
  ];

  final Map<String, double> _categoryAngles = {
    'Bags': 0,
    'Clothing': pi / 2,
    'Footwear': pi,
    'Accessories': 3 * pi / 2,
  };

  double currentAngle = 0;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _angleAnimation = Tween<double>(begin: currentAngle, end: currentAngle).animate(_controller);
    selectedCategories = [selectedCategory];
  }

  void _onNavTapped(int index) {
    setState(() => currentIndex = index);
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/scan');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  void _updateCategory(String newCategory) {
    if (newCategory == selectedCategory) return;

    final newAngle = _categoryAngles[newCategory] ?? 0;

    _angleAnimation = Tween<double>(
      begin: currentAngle,
      end: -newAngle,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller
      ..reset()
      ..forward();

    setState(() {
      selectedCategory = newCategory;
      currentAngle = -newAngle;
      selectedCategories = [newCategory];
    });
  }
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
          child: _AudioSettingsPopup(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Builder(
                              builder: (context) => IconButton(
                                icon: const Icon(Icons.menu, color: Colors.white),
                                onPressed: () => Scaffold.of(context).openDrawer(),
                              ),
                            ),
                            const Spacer(),
                            Image.asset("assets/images/logo.png", height: 40),
                            const Spacer(),
                            const Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: NotificationBell(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0), // 👈 Moves back button right
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Row(
                                  children: const [
                                    Icon(Icons.arrow_back, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text("Back", style: TextStyle(color: Colors.white, fontSize: 16)),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0), // 👈 Moves settings icon right
                              child: GestureDetector(
                                onTap: () => _showSettingsDialog(context),
                                child: const Icon(Icons.settings, color: Colors.white),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 26),
                        Text(
                          "GAME MODE",
                          style: GoogleFonts.kronaOne(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "CATEGORY",
                          style: GoogleFonts.kronaOne(
                            fontSize: 14,
                            color: Colors.white70,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: SizedBox(
                            height: 340,
                            child: ClipRect(
                              child: Align(
                                alignment: Alignment.topCenter,
                                heightFactor: 2,
                                child: Container(
                                  width: 400,
                                  height: 370,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                  ),
                                  child: AnimatedBuilder(
                                    animation: _angleAnimation,
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle: _angleAnimation.value,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: categories.map((cat) {
                                            final angle = _categoryAngles[cat['label']] ?? 0;
                                            final rotatedAngle = angle + _angleAnimation.value;
                                            if (cos(rotatedAngle) < 0) return const SizedBox.shrink();

                                            final radius = 100.0;
                                            final offsetX = radius * cos(angle - pi / 2);
                                            final offsetY = radius * sin(angle - pi / 2);
                                            final isSelected = selectedCategory == cat['label'];

                                            return Transform.translate(
                                              offset: Offset(offsetX, offsetY),
                                              child: Transform.rotate(
                                                angle: -_angleAnimation.value,
                                                child: AnimatedOpacity(
                                                  opacity: isSelected ? 1.0 : 0.0,
                                                  duration: const Duration(milliseconds: 300),
                                                  child: Container(
                                                    height: 140,
                                                    width: 300,
                                                    padding: const EdgeInsets.all(4),
                                                    child: Image.asset(
                                                      cat['image']!,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: categories.map((cat) {
                            final isSelected = selectedCategory == cat['label'];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: GestureDetector(
                                onTap: () => _updateCategory(cat['label']!),
                                child: Container(
                                  constraints: const BoxConstraints(minWidth: 70),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x66000000),
                                        offset: Offset(0, 4),
                                        blurRadius: 4,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: isSelected ? Colors.white : Colors.transparent,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Text(
                                    cat['label']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _pillButton("Select", () {
                              if (selectedCategory.isNotEmpty) {
                                Navigator.pushNamed(
                                  context,
                                  '/game',
                                  arguments: [selectedCategory],
                                );
                              }
                            }),
                            const SizedBox(width: 16),
                            _pillButton("Select All", () {
                              final allLabels = categories.map((cat) => cat['label']!).toList();
                              Navigator.pushNamed(
                                context,
                                '/game',
                                arguments: allLabels,
                              );
                            }),
                          ],
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: _onNavTapped,
        isMarketplace: false,
        isGame: true,
      ),
    );
  }

  Widget _pillButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 1.4),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


// Audio Settings Dialog

class _AudioSettingsPopup extends StatefulWidget {
  const _AudioSettingsPopup();

  @override
  State<_AudioSettingsPopup> createState() => _AudioSettingsPopupState();
}

class _AudioSettingsPopupState extends State<_AudioSettingsPopup> {
  double masterVolume = 0.7;
  double sfxVolume = 0.9;

  double previousMasterVolume = 0.7;
  double previousSfxVolume = 0.9;

  bool isMasterMuted = false;
  bool isSfxMuted = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final popupWidth = math.min(screenWidth * 0.79, 500.0); // 90% of screen or 500 max

    return Center(
      child: UnconstrainedBox(
        child: SizedBox(
          width: popupWidth.toDouble(),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const RadialGradient(
                          center: Alignment(0, -0.2),
                          radius: 1.2,
                          colors: [
                            Color(0x2FFFFFFF),
                            Color(0x33FFFFFF),
                          ],
                          stops: [0.1, 1.0],
                        ),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "SETTINGS",
                            style: GoogleFonts.kronaOne(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildVolumeRow("Master Volume", masterVolume, (val) {
                            setState(() {
                              masterVolume = val;
                              if (val > 0) isMasterMuted = false;
                            });
                          }),
                          const SizedBox(height: 20),
                          _buildVolumeRow("SFX Volume", sfxVolume, (val) {
                            setState(() {
                              sfxVolume = val;
                              if (val > 0) isSfxMuted = false;
                            });
                          }),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _AudioIconButton(
                                icon: isMasterMuted ? Icons.music_off : Icons.music_note,
                                onTap: () {
                                  setState(() {
                                    if (isMasterMuted) {
                                      masterVolume = previousMasterVolume;
                                      isMasterMuted = false;
                                    } else {
                                      previousMasterVolume = masterVolume;
                                      masterVolume = 0.0;
                                      isMasterMuted = true;
                                    }
                                  });
                                },
                              ),
                              const SizedBox(width: 24),
                              _AudioIconButton(
                                icon: isSfxMuted ? Icons.volume_off : Icons.volume_up,
                                onTap: () {
                                  setState(() {
                                    if (isSfxMuted) {
                                      sfxVolume = previousSfxVolume;
                                      isSfxMuted = false;
                                    } else {
                                      previousSfxVolume = sfxVolume;
                                      sfxVolume = 0.0;
                                      isSfxMuted = true;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
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
    );
  }

  Widget _buildVolumeRow(String label, double value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (details) {
                  final newWidth = (details.localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0);
                  onChanged(newWidth);
                },
                onTapDown: (details) {
                  final newWidth = (details.localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0);
                  onChanged(newWidth);
                },
                child: Container(
                  height: 30,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1),
                    color: Colors.transparent,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Stack(
                      children: [
                        FractionallySizedBox(
                          widthFactor: value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE0E0E0), Color(0xFF8B8B8B)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AudioIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AudioIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white12,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

