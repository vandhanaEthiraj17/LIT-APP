import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:flutter/scheduler.dart';
import '../widgets/notification_bell.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  int currentIndex = -1;
  List<String> selectedCategories = [];
  int secondsRemaining = 15;
  Timer? countdownTimer;
  bool _hasStarted = false;
  Timer? _timer;

  bool isFlipped = false;
  bool _showRealCards = false;

  late AnimationController _flipController1;
  late AnimationController _flipController2;
  late Animation<double> _animation1;
  late Animation<double> _animation2;

  // Shoe selection state
  int? _selectedOption; // 1 = shoe1, 2 = shoe2
  int _coins = 0;
  int _hearts = 3;
  static const String _shoe1Price = '₹93,499';
  static const String _shoe2Price = '₹3,500';

  void _selectOption(int option) {
    setState(() {
      _selectedOption = option;
      if (option == 1) {
        _coins += 5;
      } else {
        _hearts = (_hearts - 1).clamp(0, 999);
      }
    });
  }

  void _undoSelection() {
    setState(() {
      if (_selectedOption == 2) {
        _hearts += 1;
      } else if (_selectedOption == 1) {
        _coins = (_coins - 5).clamp(0, 999);
      }

      _selectedOption = null;
    });
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
  void _startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => secondsRemaining--);
      }
    });
  }


  @override
  void dispose() {
    _flipController1.dispose();
    _flipController2.dispose();
    countdownTimer?.cancel();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();

    _flipController1 = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _flipController2 = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation1 = Tween<double>(begin: 0, end: 1).animate(_flipController1);
    _animation2 = Tween<double>(begin: 0, end: 1).animate(_flipController2);
  }




  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is List<String>) {
      selectedCategories = args;
    }

    return WillPopScope(
      onWillPop: () async {
        _showExitConfirmation(context);
        return false; // prevent immediate exit
      },
      child: Scaffold(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        Image.asset("assets/images/logo.png", height: 36),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(right: 0),
                          child: NotificationBell(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => _showExitConfirmation(context),
                          child: Row(
                            children: const [
                              Icon(Icons.arrow_back, color: Colors.white),
                              SizedBox(width: 8),
                              Text("Back", style: TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showSettingsDialog(context),
                          child: const Icon(Icons.settings, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            "assets/images/avatar.jpg",
                            height: 42,
                            width: 42,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("LuxuryinTaste",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text("Beginner", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _resourceIcon('assets/images/heart.png', '6'),
                        const SizedBox(width: 8),
                        _resourceIcon('assets/images/diamond.png', '6'),
                        const SizedBox(width: 8),
                        _resourceIcon('assets/images/fire.png', '6'),
                        const SizedBox(width: 8),
                        _resourceIcon('assets/images/purple_star.png', '2803'),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Center(
                      child: Text(
                        "Which One Looks More Expensive ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Inside your build method or main column (where the body is rendered)
                    !_hasStarted
                        ? buildStartPlaceholder()
                        : _buildGameBody(),



                    const SizedBox(height: 20),
                  ],
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
      ),
    );
  }

  Widget _buildGameBody() {
    return Column(
      children: [
        Row(
          children: [
            // Shoe 1
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _selectOption(1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (_selectedOption == 1)
                        BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.8),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                    ],
                  ),
                  child: _selectionCard(
                    imagePath: 'assets/images/shoe1.png',
                    label: 'BALENCIAGA',
                    scaleUp: _selectedOption == 1,
                    showPrice: _selectedOption != null,
                    price: _shoe1Price,
                    glowColor: _selectedOption == 1 ? Colors.greenAccent : Colors.transparent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Shoe 2
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _selectOption(2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (_selectedOption == 2)
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.8),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                    ],
                  ),
                  child: _selectionCard(
                    imagePath: 'assets/images/shoe2.png',
                    label: 'CONVERSE',
                    scaleUp: _selectedOption == 2,
                    showPrice: _selectedOption != null,
                    price: _shoe2Price,
                    glowColor: _selectedOption == 2 ? Colors.redAccent : Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        const SizedBox(height: 12),
        if (_selectedOption != null)
          Column(
            children: [
              if (_selectedOption == 1) ...[
                const Text(
                  'Correct Answer',
            style: TextStyle(
                    color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
                ),
                const SizedBox(height: 6),
                Image.asset('assets/images/gold_star.png', width: 60, height: 60),
              ] else ...[
                const Text(
                  'Wrong Answer',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Image.asset('assets/images/heart.png', width: 60, height: 60),
              ],
            ],
          ),
        const SizedBox(height: 12),
        if (_selectedOption != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedOption == 2)
                _primaryButton('Undo', _undoSelection),
              if (_selectedOption == 2) const SizedBox(width: 12),
              _primaryButton('Next', () {
                setState(() {
                  _selectedOption = null; // reset for next round
                });
              }),
              const SizedBox(width: 12),
              _primaryButton('Exit', () => Navigator.pop(context)),
            ],
          ),
        Center(
          child: Text(
            "00:${secondsRemaining.toString().padLeft(2, '0')}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (_selectedOption == null)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ActionButton(
              label: "Hint",
              onPressed: () => _showSkipDialog(
                context,
                "Are you sure you want a hint?",
                "Hint 5",
              ),
            ),
            const SizedBox(width: 16),
            _ActionButton(
              label: "Skip",
              onPressed: () => _showSkipDialog(
                context,
                "Are you sure you want to skip?",
                "Skip 5",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildStartPlaceholder() {
    return Column(
      children: [
        Row(
          children: [
            // 🔹 Left card (flip from left)
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (child, animation) {
                  final rotateAnim = Tween(begin: math.pi, end: 0.0).animate(animation);
                  return AnimatedBuilder(
                    animation: rotateAnim,
                    child: child,
                    builder: (context, child) {
                      final isUnder = (ValueKey(_hasStarted) != child!.key);
                      final tilt = (rotateAnim.value <= math.pi / 2 ? 1.0 : -1.0);
                      final transform = Matrix4.rotationY(rotateAnim.value * tilt);
                      return Transform(
                        transform: transform,
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                  );
                },
                child: isFlipped
                    ? _buildOptionCard("assets/images/shoe1.png", "Option 1")
                    : _buildPlaceholderCard("Option 1", key: const ValueKey(false)),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
              ),
            ),

            const SizedBox(width: 16),

            // 🔹 Right card (flip from right)
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (child, animation) {
                  final rotateAnim = Tween(begin: -math.pi, end: 0.0).animate(animation);
                  return AnimatedBuilder(
                    animation: rotateAnim,
                    child: child,
                    builder: (context, child) {
                      final isUnder = (ValueKey(_hasStarted) != child!.key);
                      final tilt = (rotateAnim.value <= math.pi / 2 ? 1.0 : -1.0);
                      final transform = Matrix4.rotationY(rotateAnim.value * tilt);
                      return Transform(
                        transform: transform,
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                  );
                },
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: isFlipped
                    ? _buildOptionCard("assets/images/shoe2.png", "Option 2")
                    : _buildPlaceholderCard("Option 2", key: const ValueKey(false)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 60),

        // 🔹 Start Now button
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isFlipped = true;
              });

              // Delay before actually starting game
              Future.delayed(const Duration(milliseconds: 800), () {
                setState(() {
                  _hasStarted = true;
                });
                _startTimer();
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const RadialGradient(
                  center: Alignment(0.08, 0.08),
                  radius: 7.98,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.8),
                    Color.fromRGBO(147, 51, 234, 0.4),
                  ],
                  stops: [0.0, 0.5],
                ),
                border: Border.all(color: Color(0xFFAEAEAE), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Text(
                "Start Now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderCard(String label, {Key ? key}) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(top: 10),
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
        border: Border.all(color: Color(0xFFAEAEAE), width: 1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), offset: Offset(0, 4), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Center(
                  child: Text(
                    "?",
                    style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -1.5,
                right: -1,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Color(0xFF491E75), width: 2),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.bookmark_border, size: 20, color: Color(0xFF491E75)),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
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
              border: const Border(
                top: BorderSide(color: Color(0xFFAEAEAE), width: 1),
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSkipDialog(BuildContext context, String title, String buttonText) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 360,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color.fromRGBO(255, 255, 255, 0.06),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // CONTINUE BUTTON
                          Container(
                            decoration: BoxDecoration(
                              gradient: const RadialGradient(
                                center: Alignment(0.1, 0.1),
                                radius: 8,
                                colors: [
                                  Color.fromRGBO(0, 0, 0, 0.8),
                                  Color.fromRGBO(147, 51, 234, 0.4),
                                ],
                              ),
                              border: Border.all(
                                color: Color(0xFFAEAEAE),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(21),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x66000000),
                                  offset: Offset(0, 4),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Continue',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // SKIP/HINT BUTTON
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromRGBO(55, 23, 74, 0.8),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.all(1.5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  foregroundColor: const Color(0xffe2c1ff),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // TODO: Add logic for hint or skip here
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      buttonText,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 6),
                                    Transform.rotate(
                                      angle: 1.2,
                                      child: Image.asset(
                                        'assets/images/diamond.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color.fromRGBO(255, 255, 255, 0.06),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Are you sure you want to leave?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // CONTINUE BUTTON
                          Container(
                            decoration: BoxDecoration(
                              gradient: const RadialGradient(
                                center: Alignment(0.1, 0.1),
                                radius: 8,
                                colors: [
                                  Color.fromRGBO(0, 0, 0, 0.8),
                                  Color.fromRGBO(147, 51, 234, 0.4),
                                ],
                              ),
                              border: Border.all(color: Color(0xFFAEAEAE), width: 1),
                              borderRadius: BorderRadius.circular(21),
                            ),
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Continue', style: TextStyle(fontSize: 15)),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // EXIT BUTTON WITH HEART ON TOP-RIGHT
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromRGBO(55, 23, 74, 0.8),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.all(1.5),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/game-modes'); // go back
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 36),
                                    foregroundColor: const Color(0xffe2c1ff),
                                  ),
                                  child: const Text("Exit", style: TextStyle(fontSize: 15)),
                                ),
                              ),

                              // Positioned Heart
                              Positioned(
                                top: -10,
                                right: -6,
                                child: Transform.rotate(
                                      angle: 0.0,
                                      child: Image.asset(
                                        'assets/images/heart.png',
                                        width: 22,
                                        height: 22,
                                      ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
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

  static Widget _resourceIcon(String asset, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white38.withOpacity(0.20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.asset(asset, width: 20, height: 20),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildOptionCard(String imagePath, String label) {
    return Container(
        margin: const EdgeInsets.only(top: 8),
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
          border: Border.all(color: Color(0xFFAEAEAE), width: 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x66000000), offset: Offset(0, 4), blurRadius: 4),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Center(
                    child: Image.asset(imagePath, height: 130, fit: BoxFit.contain),
                  ),
                ),
                Positioned(
                  top: -1.5,
                  right: -1,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Color(0xFF491E75), width: 2),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.bookmark_border, size: 20, color: Color(0xFF491E75)),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
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
                border: const Border(
                  top: BorderSide(color: Color(0xFFAEAEAE), width: 1),
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
      ),
    );
  }

  Widget _selectionCard({
    required String imagePath,
    required String label,
    required bool scaleUp,
    required bool showPrice,
    required String price,
    required Color glowColor,
  }) {
    return Container(
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
        border: Border.all(color: const Color(0xFFAEAEAE), width: 1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (glowColor != Colors.transparent)
            BoxShadow(color: glowColor.withOpacity(0.85), blurRadius: 20, spreadRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Center(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 200),
                    scale: scaleUp ? 1.1 : 1.0,
                    child: Image.asset(imagePath, height: 130, fit: BoxFit.contain),
                  ),
                ),
              ),
              Positioned(
                top: -1.5,
                right: -1,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: const Color(0xFF491E75), width: 2),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.bookmark_border, size: 20, color: Color(0xFF491E75)),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.08, 0.08),
                radius: 7.98,
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.8),
                  Color.fromRGBO(147, 51, 234, 0.4),
                ],
                stops: [0.0, 0.5],
              ),
              border: Border(
                top: BorderSide(color: Color(0xFFAEAEAE), width: 1),
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (showPrice)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      price,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton(String label, VoidCallback onPressed) {
    return Container(
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
        border: Border.all(color: const Color(0xFFAEAEAE), width: 1),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), offset: Offset(0, 4), blurRadius: 4),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }


}

// Hint / Skip Button
class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
              border: Border.all(color: Color(0xFFAEAEAE), width: 1),
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  offset: Offset(0, 4),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            top: -8,
            right: -8,
            child: Transform.rotate(
              angle: 0.9,
              child: Image.asset(
                'assets/images/diamond.png',
                height: 24,
                width: 24,
              ),
            ),
          ),
        ],
      ),
    );
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
                          const SizedBox(height: 24),
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
                          const SizedBox(height: 24),
                          // Action pills
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              _settingsPill(
                                icon: Icons.info_outline,
                                label: 'How to Play',
                                onTap: () {},
                              ),
                              _settingsPill(
                                icon: Icons.privacy_tip_outlined,
                                label: 'Privacy',
                                onTap: () {},
                              ),
                              _settingsPill(
                                icon: Icons.gavel_outlined,
                                label: 'Terms of Service',
                                onTap: () {},
                              ),
                              _settingsPill(
                                icon: Icons.headset_mic_outlined,
                                label: 'Help And Support',
                                onTap: () {},
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

  Widget _settingsPill({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
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
                            child: Center(
                              child: Text(
                                '${(value * 100).round()}%',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
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
