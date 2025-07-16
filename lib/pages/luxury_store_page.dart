import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';

class LuxuryStorePage extends StatefulWidget {
  const LuxuryStorePage({super.key});

  @override
  State<LuxuryStorePage> createState() => _LuxuryStorePageState();
}

class _LuxuryStorePageState extends State<LuxuryStorePage> {
  final List<String> _searchHints = [
    'Search luxury men fashion',
    'Search designer women wear',
    'Search premium accessories',
    'Search luxury items',
  ];

  int _hintIndex = 0;
  String _currentHint = '';
  int _charIndex = 0;
  Timer? _typingTimer;
  Timer? _pauseTimer;

  int activeOverlayIndex = -1;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_charIndex < _searchHints[_hintIndex].length) {
        setState(() {
          _currentHint += _searchHints[_hintIndex][_charIndex];
          _charIndex++;
        });
      } else {
        _typingTimer?.cancel();
        _pauseTimer = Timer(const Duration(seconds: 2), () {
          setState(() {
            _hintIndex = (_hintIndex + 1) % _searchHints.length;
            _currentHint = '';
            _charIndex = 0;
          });
          _startTyping();
        });
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _pauseTimer?.cancel();
    super.dispose();
  }

  void _onTabTapped(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/cart');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset('assets/images/logo.png', height: 40),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.favorite_outline, color: Colors.white),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: -1,
        onTap: (index) => _onTabTapped(context, index),
        isMarketplace: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/background.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: _currentHint,
                              hintStyle: const TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const Icon(Icons.search, color: Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _TapOverlayCard(
                    index: 0,
                    isActive: activeOverlayIndex == 0,
                    onToggle: () {
                      setState(() {
                        activeOverlayIndex = activeOverlayIndex == 0 ? -1 : 0;
                      });
                    },
                    imagePath: 'assets/images/men_collection.png',
                    title: "Men's Collection",
                    subtitle: "Discover the latest designer and luxury fashion for men",
                  ),
                  const SizedBox(height: 20),
                  _TapOverlayCard(
                    index: 1,
                    isActive: activeOverlayIndex == 1,
                    onToggle: () {
                      setState(() {
                        activeOverlayIndex = activeOverlayIndex == 1 ? -1 : 1;
                      });
                    },
                    imagePath: 'assets/images/women_collection.png',
                    title: "Women's Collection",
                    subtitle: "Explore high-end and exclusive luxury fashion for women",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TapOverlayCard extends StatelessWidget {
  final int index;
  final bool isActive;
  final VoidCallback onToggle;
  final String imagePath;
  final String title;
  final String subtitle;

  const _TapOverlayCard({
    required this.index,
    required this.isActive,
    required this.onToggle,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.asset(imagePath, width: double.infinity, height: 280, fit: BoxFit.cover),
            Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        )),
                  ],
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: isActive ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: double.infinity,
                height: 280,
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _glassButton("Shop All"),
                        const SizedBox(height: 10),
                        _glassButton("Clothing"),
                        const SizedBox(height: 10),
                        _glassButton("Shoes"),
                        const SizedBox(height: 10),
                        _glassButton("Bags"),
                        const SizedBox(height: 10),
                        _glassButton("Accessories"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassButton(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8), // smaller height
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: Text(text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              )),
        ),
      ),
    );
  }
}
