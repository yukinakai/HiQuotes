import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_quotes/model/quote.dart';
import 'package:flutter/material.dart';

final quoteProvider = StateProvider<Quote>((ref) {
  return Quote();
});

// final imageKeyProvider = StateProvider.autoDispose<GlobalKey?>((ref) => null);
