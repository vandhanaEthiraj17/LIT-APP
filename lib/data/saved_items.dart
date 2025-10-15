class SavedItems {
  static List<Map<String, dynamic>> items = [];

  static void addItem({
    required String imagePath,
    required String label,
    required String price,
  }) {
    if (!items.any((item) => item['label'] == label)) {
      items.add({
        'imagePath': imagePath,
        'label': label,
        'price': price,
      });
    }
  }

  static void removeItem(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
    }
  }
}


