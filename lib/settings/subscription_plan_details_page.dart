import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';
import 'package:lit/widgets/lit_feature_section.dart';
import '../widgets/notification_bell.dart';
import '../widgets/subscription_plan_comparison_table.dart';

class SubscriptionPlanPage extends StatefulWidget {
  const SubscriptionPlanPage({super.key});

  @override
  State<SubscriptionPlanPage> createState() => _SubscriptionPlanPageState();
}

class _SubscriptionPlanPageState extends State<SubscriptionPlanPage> {
  int currentIndex = -1;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _comparisonKey = GlobalKey();

  final PageController _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.95,
  );

  late final List<Widget> _plans;

  @override
  void initState() {
    super.initState();
    _plans = [
      _buildStarterPlanCard(),
      _buildMonthlyPlanCard(),
      _buildWeeklyPlanCard(),
    ];
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
          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      Image.asset('assets/images/logo.png', height: 40),
                      const NotificationBell(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Back",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Choose the plan that fits your needs.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Swipe to see Plans",
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      SizedBox(
                        height: 650,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _plans.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: _plans[index],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Scrollable.ensureVisible(
                              _comparisonKey.currentContext!,
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOut,
                              alignment: 0.1,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            ),
                            child: const Text(
                              "Compare plans",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "Choose the Mode that Matches Your Style",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.w900,
                            height: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 36),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ALWAYS FREE Label
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                "✓  ALWAYS FREE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Player Mode Title
                            const Text(
                              "Player Mode",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Player Mode Description
                            const Text(
                              "Free users can play games, discover styles, and earn points with limited access to features. Great for casual discovery and trying out the experience.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 20),

                            // Divider
                            Container(
                              width: 80,
                              height: 1,
                              color: Colors.white30,
                            ),

                            const SizedBox(height: 20),

                            // PAID Label
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                "\$  PAID",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Style Mode Title
                            const Text(
                              "Style Mode",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Style Mode Description
                            const Text(
                              "Premium users unlock the full power of play-to-shop — with faster lives, exclusive drops, and special sales.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 5),
                      KeyedSubtree(
                        key: _comparisonKey,
                        child: const PlanComparisonSection(),
                      ),

                      LitFeaturesSection()


                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: _onNavTapped,
        isMarketplace: false,
      ),
    );
  }

  // ---------------- PLAN CARDS ----------------

  Widget _buildGlassCard(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String subtitle,
    required String price,
    required String buttonText,
    required List<String> features,
    required List<String> keyFeatures,
    required Color backgroundColor,
    Color titleColor = Colors.black,
    Color textColor = Colors.black87,
    Color dividerColor = Colors.black26,
    bool isLightTheme = true,
    bool useGradientButton = false,
    bool useGlass = false,
  }) {
    final cardContent = Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: titleColor)),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(color: textColor)),
          const SizedBox(height: 20),
          Text(price, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: titleColor)),
          const SizedBox(height: 18),
          Center(
            child: useGradientButton
                ? Container(
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
                border: Border.all(color: Color(0xFFBBBDF1), width: 2),
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            )
                : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black54, width: 3),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text("• $f", style: TextStyle(color: textColor)),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: dividerColor),
          ),
          Text("Key Features", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 16),
          ...keyFeatures.map((text) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(Icons.check, size: 18, color: isLightTheme ? Colors.green : Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text(text, style: TextStyle(color: textColor))),
              ],
            ),
          )),
        ],
      ),
    );

    return useGlass
        ? _buildGlassCard(cardContent)
        : Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: cardContent,
    );
  }

  Widget _buildMonthlyPlanCard() {
    return _buildPlanCard(
      title: "Monthly",
      subtitle: "Full access + exclusive benefits",
      price: "\$499",
      buttonText: "Subscribe Now",
      backgroundColor: Colors.white,
      features: const [
        "Faster life regeneration (15 mins)",
        "Exclusive 8-min Midnight Sale (80% OFF)",
        "VIP Badge on Leaderboard",
        "Sneak peek into upcoming products",
      ],
      keyFeatures: const [
        "Exclusive fashion badge shown beside your name",
        "5 lives/day",
        "Earn points & redeem",
        "Limited access to product details",
      ],
      isLightTheme: true,
      useGradientButton: true,
    );
  }

  Widget _buildStarterPlanCard() {
    return _buildPlanCard(
      title: "Starter",
      subtitle: "Quick access to try & play",
      price: "Free",
      buttonText: "Get Started – It’s Free",
      backgroundColor: Colors.transparent,
      features: const [
        "Play limited fashion games",
        "Life regeneration: 30 mins",
        "Access streaks & leaderboards",
        "Up to 5 product saves",
      ],
      keyFeatures: const [
        "Screen recording & cam bubble",
        "5 lives/day",
        "Earn points & redeem",
        "Limited access to product details",
      ],
      titleColor: Colors.white,
      textColor: Colors.white,
      dividerColor: Colors.white24,
      isLightTheme: false,
      useGlass: true,
    );
  }

  Widget _buildWeeklyPlanCard() {
    return _buildPlanCard(
      title: "Weekly",
      subtitle: "Get ahead with style",
      price: "\$999",
      buttonText: "Try 1 Week Now",
      backgroundColor: Colors.transparent,
      features: const [
        "Save both right & wrong answers",
        "Life regeneration every 20 mins",
        "View answer history anytime",
        "Access exclusive sale alerts",
      ],
      keyFeatures: const [
        "Exclusive fashion badge shown beside your name",
        "Save fashion streak",
        "Earn points & redeem",
        "Limited access to product details",
      ],
      titleColor: Colors.white,
      textColor: Colors.white,
      dividerColor: Colors.white24,
      isLightTheme: false,
      useGlass: true,
    );
  }
}
