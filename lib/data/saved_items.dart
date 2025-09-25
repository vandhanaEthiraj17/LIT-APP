class SavedItems {
  // Simple in-memory store for saved items across pages
  static final List<Map<String, String>> items = <Map<String, String>>[];

  static void addItem({required String imagePath, required String label}) {
    items.add({'image': imagePath, 'label': label});
  }

  static void removeAt(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
    }
  }
}


