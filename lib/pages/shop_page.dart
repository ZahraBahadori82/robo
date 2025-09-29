import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/coffee_tile.dart';
import '../models/coffee_shop.dart';
import '../models/coffee.dart';
import 'coffee_details_page.dart'; // صفحه جدید

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeShop>(
      builder: (context, value, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              // heading message
              const Text(
                "How would you like your coffee?",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 25),

              // list of coffee to buy
              Expanded(
                child: ListView.builder(
                  itemCount: value.coffeeShop.length,
                  itemBuilder: (context, index) {
                    Coffee eachCoffee = value.coffeeShop[index];

                    return CoffeeTile(
                      coffee: eachCoffee,
                      icon: const Icon(Icons.trending_flat_rounded),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CoffeeDetailPage(coffee: eachCoffee),
                          ),

                        );
                      },
                      showMultiplication: false, // 👈 Hides it here

                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
