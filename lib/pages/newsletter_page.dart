import 'package:flutter/material.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit/pages/newsletter_detail_page.dart';

import '../widgets/notification_bell.dart';


class NewsletterPage extends StatefulWidget {
  final String? scrollToSection; // 'sustainable', 'luxury', 'fast', 'sneaker'

  const NewsletterPage({super.key, this.scrollToSection});

  @override
  State<NewsletterPage> createState() => _NewsletterPageState();
}

class _NewsletterPageState extends State<NewsletterPage> {
  bool isInternational = true;
  // 🔑 Add these keys to mark section positions
  final sustainableKey = GlobalKey();
  final luxuryKey = GlobalKey();
  final fastFashionKey = GlobalKey();
  final sneakerKey = GlobalKey();

  // 🎯 Add this scroll controller for manual scroll control
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToTarget();
    });
  }

  void _scrollToTarget() {
    final section = widget.scrollToSection;
    BuildContext? contextToScroll;

    switch (section) {
      case 'sustainable':
        contextToScroll = sustainableKey.currentContext;
        break;
      case 'luxury':
        contextToScroll = luxuryKey.currentContext;
        break;
      case 'fast':
        contextToScroll = fastFashionKey.currentContext;
        break;
      case 'sneaker':
        contextToScroll = sneakerKey.currentContext;
        break;
    }

    if (contextToScroll != null) {
      Scrollable.ensureVisible(
        contextToScroll,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }


  void _onTabTapped(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/ir_icon');
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
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 0),
            child: NotificationBell(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: -1,
        onTap: (index) => _onTabTapped(context, index),
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
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner
                  Stack(
                    children: [
                      Image.asset(
                        'assets/images/newsletter_banner.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 30,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            "NEWSLETTER",
                            style: GoogleFonts.kronaOne(
                              color: Colors.white,
                              fontSize: 26,
                              letterSpacing: 5,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => isInternational = true),
                              child: Column(
                                children: [
                                  Text(
                                    "INTERNATIONAL",
                                    style: GoogleFonts.kronaOne(
                                      color: Colors.white,
                                      fontSize: 12,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    height: 3,
                                    width: 100,
                                    color: isInternational ? Colors.white : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 40),
                            GestureDetector(
                              onTap: () => setState(() => isInternational = false),
                              child: Column(
                                children: [
                                  Text(
                                    "DOMESTIC",
                                    style: GoogleFonts.kronaOne(
                                      color: Colors.white,
                                      fontSize: 12,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    height: 3,
                                    width: 100,
                                    color: !isInternational ? Colors.white : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  sectionTitle("SUSTAINABLE FASHION", key: sustainableKey),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.1),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      key: ValueKey(isInternational), // triggers switch
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sustainableFashionGrid(),
                        sectionTitle("LUXURY FASHION", key: luxuryKey),
                        luxuryFashionGrid(),
                        sectionTitle("FAST FASHION", key: fastFashionKey),
                        fastFashionSection(),
                        Container(key: sneakerKey, child: sneakerWorldSection()),
                      ],
                    ),
                  ),
                  // Sections

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title, {Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget sustainableFashionGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: sustainableCard(
                      isInternational ? 'assets/images/n1.jpg' : 'assets/images/d1.jpg',
                      isInternational ? "Swap Your Gold Chains for This Necklace Trend" : "Domestic Your Gold Chains for This Necklace Trend",
                  )
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: sustainableCard(
                      isInternational ? 'assets/images/n2.jpg' : 'assets/images/d2.jpg',
                      isInternational ? "Swap Your Gold Chains for This Necklace Trend" : "Domestic Your Gold Chains for This Necklace Trend",
                  )
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: sustainableCard(
                      isInternational ? 'assets/images/n3.jpg' : 'assets/images/d3.jpg',
                      isInternational ? "Swap Your Gold Chains for This Necklace Trend" : "Domestic Your Gold Chains for This Necklace Trend",
                  )
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: sustainableCard(
                      isInternational ? 'assets/images/n4.jpg' : 'assets/images/d4.jpg',
                      isInternational ? "Swap Your Gold Chains for This Necklace Trend" : "Domestic Your Gold Chains for This Necklace Trend",
                  )
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget sustainableCard(String path, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsletterDetailPage(imagePath: path, title: title),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(path, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "Swap Your Gold Chains for This Necklace Trend",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget luxuryFashionGrid() {
    return Column(
      children: [
        luxuryCard(
            isInternational ? 'assets/images/n5.jpg' : 'assets/images/d5.jpg',
            isInternational ? "Swap Your Gold Chains for This Necklace Trend" : "Domestic Your Gold Chains for This Necklace Trend",
        ),
        const SizedBox(height: 16),
        luxuryCard(
            isInternational ? 'assets/images/n6.jpg' : 'assets/images/d6.jpg',
            isInternational ? "Swap Your Gold Chains for This Necklace Trend" : "Domestic Your Gold Chains for This Necklace Trend",
        ),
      ],
    );
  }

  Widget luxuryCard(String imagePath, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsletterDetailPage(imagePath: imagePath, title: title),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.asset(
                imagePath,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Swap Your Gold Chains for This Necklace Trend",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "Learn more",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, color: Colors.white70, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget fastFashionSection() {
    return Column(
      children: [
        fastFashionCard(
            isInternational ? 'assets/images/n7.jpg' : 'assets/images/d7.jpg',
            isInternational ? "Swap Your Gold Chains for This Necklace Trend" : "Domestic Your Gold Chains for This Necklace Trend",
        ),
        const SizedBox(height: 16),
        fastFashionCard(isInternational ? 'assets/images/n8.jpg' : 'assets/images/d8.jpg'
            , isInternational ? "Swap Your Gold Chains for This Necklace Trend" : "Domestic Your Gold Chains for This Necklace Trend",),
      ],
    );
  }

  Widget fastFashionCard(String imagePath, String title ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsletterDetailPage(imagePath: imagePath, title: title),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.asset(
                imagePath,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Swap Your Gold Chains for This Necklace Trend",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "Learn more",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, color: Colors.white70, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget sneakerWorldSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            "THE SNEAKER WORLD",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           children: [
              Image.asset(
                isInternational ? 'assets/images/sneaker1.png' : 'assets/images/sneaker1.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Expanded(
                    child: Text(
                      "Puma’s Speed cat Ballet Sneaker Is Trending",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: sneakerGridCard(
                      isInternational ? 'assets/images/sneaker2.png' : 'assets/images/sneaker2.png',
                      isInternational ? "Swap Your Gold Chains for This Necklace Trend" : "Domestic Your Gold Chains for This Necklace Trend",
                  )
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: sneakerGridCard(
                      isInternational ? 'assets/images/sneaker3.png' : 'assets/images/sneaker3.png',
                      isInternational ? "Swap Your Gold Chains for This Necklace Trend" : "Domestic Your Gold Chains for This Necklace Trend",
                  )
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget sneakerGridCard(String imagePath, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsletterDetailPage(imagePath: imagePath, title: title),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Expanded(
                child: Text(
                  "Puma’s Speed cat Ballet Sneaker Is Trending",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.arrow_forward, color: Colors.white, size: 14),
            ],
          ),
        ],
      ),
    );
  }
}
