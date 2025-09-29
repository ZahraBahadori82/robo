import 'package:flutter/material.dart';
import 'coffee.dart';
import 'coffee_order.dart'; // فایل جدید مدل بالا

class CoffeeShop extends ChangeNotifier {
  final List<Coffee> _shop = [
    Coffee(name: 'black coffee', price: 75000, imagePath: "lib/image/black_coffee.webp"),
    Coffee(name: 'latte', price: 120000, imagePath: "lib/image/latte.webp"),
    Coffee(name: 'espresso', price: 60000, imagePath: "lib/image/esperesso.webp"),
    Coffee(name: 'cappuccino', price: 70000, imagePath: "lib/image/cappuccino.webp"),
    Coffee(name: 'iced coffee', price: 110000, imagePath: "lib/image/iced_coffee.webp"),
  ];
  // USER CART
  final List<Coffee> _userCart = [];

  // GET coffee list
  List<Coffee> get coffeeShop => _shop;

  // GET user cart
  List<Coffee> get userCart => _userCart;

  // ADD item to cart
  void addItemToCart(Coffee coffee, int quantity, String size) {
    Coffee customCoffee = Coffee(
      name: coffee.name,
      price: coffee.price,
      imagePath: coffee.imagePath,
      quantity: quantity,
      size: size,
    );

    _userCart.add(customCoffee);
    notifyListeners();
  }


  // REMOVE item from cart
  void removeItemFromCart(Coffee coffee) {
    _userCart.remove(coffee);
    notifyListeners();
  }

  // CLEAR cart
  void clearCart() {
    _userCart.clear();
    notifyListeners();
  }
}