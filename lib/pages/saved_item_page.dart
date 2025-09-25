import 'package:flutter/material.dart';
import 'package:lit/data/saved_items.dart';

class SavedItemPage extends StatefulWidget {
  const SavedItemPage({super.key});

  @override
  State<SavedItemPage> createState() => _SavedItemPageState();
}

class _SavedItemPageState extends State<SavedItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Items'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Your Saved Items',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SavedItems.items.isEmpty
                        ? const Center(
                            child: Text(
                              'No saved items yet',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: SavedItems.items.length,
                            itemBuilder: (context, index) {
                              final item = SavedItems.items[index];
                              return _buildSavedItemCard(item);
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9333EA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Back to Game'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSavedItemCard(Map<String, dynamic> item) {
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
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), offset: Offset(0, 4), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Image.asset(
                  item['imagePath'],
                  fit: BoxFit.contain,
                ),
              ),
            ),
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
            child: Text(
              item['label'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}