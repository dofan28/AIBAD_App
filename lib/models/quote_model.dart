import 'package:final_project/models/quote_item.dart';

class QuoteModel {
  String feeling;
  List<QuoteItem> quotes;

  QuoteModel({required this.feeling, required this.quotes});

  factory QuoteModel.fromMap(Map<String, dynamic> map) {
    var list = map['quotes'] as List<dynamic>? ?? [];
    List<QuoteItem> quotes = list
        .map((item) => QuoteItem.fromMap(item as Map<String, dynamic>))
        .toList();
    return QuoteModel(
      feeling: map['feeling'],
      quotes: quotes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'feeling': feeling,
      'quotes': quotes.map((quote) => quote.toMap()).toList(),
    };
  }
}
