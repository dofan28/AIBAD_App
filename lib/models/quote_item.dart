class QuoteItem {
  bool isFavorite;
  String quote;

  QuoteItem({this.isFavorite = false, required this.quote});

  factory QuoteItem.fromMap(Map<String, dynamic> map) {
    return QuoteItem(
      isFavorite: map['isFavorite'] ?? false,
      quote: map['quote'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isFavorite': isFavorite,
      'quote': quote,
    };
  }
}
