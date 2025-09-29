import 'coffee.dart';

class CoffeeOrder {
  final Coffee coffee;
  final String size;
  final int quantity;

  CoffeeOrder({
    required this.coffee,
    required this.size,
    required this.quantity,
  });
}
