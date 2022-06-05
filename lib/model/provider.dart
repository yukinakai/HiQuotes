import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_quotes/model/quote.dart';

final quoteProvider = StateProvider<Quote>((ref) {
  return Quote();
});
