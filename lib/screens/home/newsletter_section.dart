import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lit/pages/newsletter_page.dart'; // Make sure to import this

class NewsletterSection extends StatefulWidget {
  const NewsletterSection({super.key});

  @override
  State<NewsletterSection> createState() => _NewsletterSectionState();
}

class _NewsletterSectionState extends State<NewsletterSection> {
  late final PageController _controller;
  Timer? _autoScrollTimer;
  double _currentPage = 0.0;

  final List<Map<String, String>> newsletters = [
    {
      'image': 'assets/images/newsletter-1.png',
      'title': "WHAT'S FAST IN FASHION.",
      'subtitle': "Stay ahead with real-time insights into the fast-paced world of fashion...",
    },
    {
      'image': 'assets/images/newsletter-2.png',
      'title': "WHAT'S NEW IN SNEAKERS.",
      'subtitle': "Step into the latest drop culture & explore trends...",
    },
    {
      'image': 'assets/images/newsletter-3.png',
      'title': "THE FUTURE OF STYLE.",
      'subtitle': "Discover the next-gen fashion tech and future-forward styles...",
    },
    {
      'image': 'assets/images/newsletter-4.png',
      'title': "SUSTAINABLE FASHION MOVES.",
      'subtitle': "How brands are embracing eco-friendly practices in style...",
    },
  ];

  static const int _initialPage = 1000;
  int get _itemCount => newsletters.length;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: _initialPage,
      viewportFraction: 0.75,
    );

    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page ?? _initialPage.toDouble();
      });
    });

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_controller.hasClients) {
        final nextPage = _controller.page!.toInt() + 1;
        _controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _goToPage(int direction) {
    final next = _controller.page!.toInt() + direction;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _currentPage.round() % _itemCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Newsletter',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _controller,
                  itemBuilder: (context, index) {
                    final actualIndex = index % _itemCount;
                    final item = newsletters[actualIndex];
                    final difference = (_currentPage - index).abs();
                    final scale = 1 - (difference * 0.1).clamp(0.0, 0.1);
                    final isFocused = difference < 0.5;

                    return Transform.scale(
                      scale: scale,
                      child: GestureDetector(
                        onTap: () {
                          String? section;
                          final title = item['title']!.toLowerCase();
                          if (title.contains('sustainable')) {
                            section = 'sustainable';
                          } else if (title.contains('sneakers')) {
                            section = 'sneaker';
                          } else if (title.contains('fast')) {
                            section = 'fast';
                          } else if (title.contains('future')) {
                            section = 'luxury';
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewsletterPage(scrollToSection: section),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                Image.asset(
                                  item['image']!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                if (!isFocused)
                                  BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.8),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title']!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.5,
                                          height: 1.3,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item['subtitle']!,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 12,
                                          height: 1.3,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.7),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Text(
                                              'Learn more',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(Icons.arrow_forward,
                                                color: Colors.white, size: 14),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Left Nav Button
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, size: 36, color: Colors.white),
                      onPressed: () => _goToPage(-1),
                    ),
                  ),
                ),

                // Right Nav Button
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.chevron_right, size: 36, color: Colors.white),
                      onPressed: () => _goToPage(1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_itemCount, (i) {
              final isActive = i == currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 12 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.white54,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
