import 'package:flutter/material.dart';
import 'package:lit/data/global_data.dart';

class SavedItemPage extends StatelessWidget {
  const SavedItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Saved Items'),
      ),
      body: ListView.separated(
        itemCount: savedGameItems.length,
        separatorBuilder: (_, __) => const Divider(color: Colors.white24),
        itemBuilder: (_, i) {
          final item = savedGameItems[i];
          return ListTile(
            leading: Image.asset(item['image']!, width: 48, height: 48, fit: BoxFit.cover),
            title: Text(item['label']!, style: const TextStyle(color: Colors.white)),
            subtitle: Text(item['price'] ?? '', style: const TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white),
          );
        },
      ),
      backgroundColor: const Color(0xFF1B0428),
    );
  }
}


