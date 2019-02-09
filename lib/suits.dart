import 'package:meta/meta.dart';

class Suit {
  final String name;
  final bool isRed;

  const Suit({@required this.isRed, @required this.name});
}

class Suits {
  static const Suit clubs = Suit(isRed: false, name: 'clubs');
  static const Suit diamonds = Suit(isRed: true, name: 'diamonds');
  static const Suit hearts = Suit(isRed: true, name: 'hearts');
  static const Suit spades = Suit(isRed: false, name: 'spades');
}