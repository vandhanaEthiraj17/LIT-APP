import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit/widgets/app_drawer.dart';
import 'package:lit/widgets/common_button.dart';

import '../widgets/notification_bell.dart';

class NewsletterDetailPage extends StatelessWidget {
  final String imagePath;
  final String title;

  const NewsletterDetailPage({
    super.key,
    required this.imagePath,
    required this.title,
  });

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
    final scrollController = ScrollController();

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
      backgroundColor: Colors.black,
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
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 10,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.6),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.kronaOne(
                          color: Colors.white,
                          fontSize: 18,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "In the new issue of Another Man, Grace Wales Bonner and Gabriel Moses sit down with Alayo Akinkugbe to discuss storytelling, Black culture, and their desire to create work that is timeless.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "JUNE 20, 2025",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _alternatingRow(
                        img: 'assets/images/n4.jpg',
                        text: _sampleParagraph(),
                        imageLeft: true,
                      ),
                      const SizedBox(height: 24),
                      _alternatingRow(
                        img: 'assets/images/n3.jpg',
                        text: _sampleParagraph(),
                        imageLeft: false,
                      ),
                      const SizedBox(height: 32),
                      _extendedStyledContentSection(),
                      const SizedBox(height: 32),
                      Text(
                        "Related Articles",
                        style: GoogleFonts.kronaOne(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 180,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: ListView(
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _relatedArticleCard(
                                    context,
                                    'assets/images/n1.jpg',
                                    'Gold Chains vs Necklace Trend',
                                  ),
                                  _relatedArticleCard(
                                    context,
                                    'assets/images/n2.jpg',
                                    'Modern Chic Jewelry Picks',
                                  ),
                                  _relatedArticleCard(
                                    context,
                                    'assets/images/n3.jpg',
                                    'Minimalist Accessories Guide',
                                  ),
                                  _relatedArticleCard(
                                    context,
                                    'assets/images/n4.jpg',
                                    'Timeless Pearls for Gen Z',
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                                onPressed: () {
                                  scrollController.animateTo(
                                    scrollController.offset - 160,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                                onPressed: () {
                                  scrollController.animateTo(
                                    scrollController.offset + 160,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),


                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _alternatingRow({
    required String img,
    required String text,
    required bool imageLeft,
  }) {
    final imageWidget = _imageBox(img);
    final textWidget = _textBox(text);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: imageLeft
          ? [
        imageWidget,
        const SizedBox(width: 16),
        Expanded(child: textWidget),
      ]
          : [
        Expanded(child: textWidget),
        const SizedBox(width: 16),
        imageWidget,
      ],
    );
  }

  Widget _imageBox(String path) {
    return SizedBox(
      width: 150,
      height: 180,
      child: Image.asset(path, fit: BoxFit.cover),
    );
  }

  Widget _textBox(String text) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ),
    );
  }

  String _sampleParagraph() {
    return "In this conversation – at the tenth anniversary of Wales Bonner and the fifth anniversary of the brand’s ongoing collaboration with Adidas – they reflect on their early impressions of each other’s work, the influence of their upbringing and their shared commitment to creating fashion and imagery that feel both personal and timeless.";
  }

  Widget _contentParagraph() {
    return const Text(
      "In the new issue of Another Man, Grace Wales Bonner and Gabriel Moses sit down with Alayo Akinkugbe to discuss storytelling, Black culture, and their desire to create work that is timeless.",
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        height: 1.6,
      ),
    );
  }

  Widget _highlightedQuote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "AA: You're both from south London, which has a distinct energy – it's a part of the city that’s culturally rich and diverse…",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontStyle: FontStyle.italic,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _extendedStyledContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _styledBlockParagraph(),
        const SizedBox(height: 12),
        _styledBlockParagraph(),
        const SizedBox(height: 12),
        _styledBlockParagraph(),
        const SizedBox(height: 24),
        Image.asset('assets/images/n5.jpg', fit: BoxFit.cover),
        const SizedBox(height: 24),
        _quoteSpeaker("AA", "You're both from south London, which has a distinct energy – it’s a part of the city that’s culturally rich and diverse, where sport, music, and fashion especially intersect. Did growing up in south London shape your visual languages, is it a reference point for either of you?"),
        const SizedBox(height: 16),
        _quoteSpeaker("GM", "Growing up in south London, you'd have this kind of healthy arrogance. Because it was like, Rio Ferdinand and Naomi Campbell and Stormzy are from here. Everything that felt far away felt really close at the same time. It was like a superpower, there's a legacy of people [from south London] achieving things on a global scale. So you grew up believing it’s possible, because someone who grew up down the road has done it. Joe Gomez, who plays for Liverpool, paid for one of my first films when I was 18. And it's that sense of community [in south London] that I hold really closely."),
      ],
    );
  }

  Widget _styledBlockParagraph() {
    return const Text(
      "In the new issue of Another Man, Grace Wales Bonner and Gabriel Moses sit down with Alayo Akinkugbe to discuss storytelling, Black culture, and their desire to create work that is timeless.",
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        height: 1.6,
      ),
    );
  }

  Widget _quoteSpeaker(String speaker, String quote) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$speaker: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: quote,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _relatedArticleCard(BuildContext context, String imgPath, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsletterDetailPage(
              imagePath: imgPath,
              title: title,
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 138, // Fixed image height
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imgPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
