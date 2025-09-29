import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robo/models/coffee.dart';
import 'package:robo/models/coffee_shop.dart';

class CoffeeDetailPage extends StatefulWidget {
  final Coffee coffee;

  const CoffeeDetailPage({super.key, required this.coffee});

  @override
  State<CoffeeDetailPage> createState() => _CoffeeDetailPageState();
}

class _CoffeeDetailPageState extends State<CoffeeDetailPage> {
  int quantity = 1;
  String selectedSize = 'Medium';
  bool addedToCart = false; // ✅ وضعیت کلیک

  final List<String> sizes = ['Small', 'Medium', 'Large'];

  void addToCart() {
    final shop = Provider.of<CoffeeShop>(context, listen: false);
    shop.addItemToCart(widget.coffee, quantity, selectedSize);

    setState(() {
      addedToCart = true; // ✅ تغییر وضعیت بعد از کلیک
    });

    // نوتیفیکیشن
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coffee.name),
        backgroundColor: Colors.brown[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Image.asset(widget.coffee.imagePath, height: 150),
            const SizedBox(height: 20),

            // انتخاب سایز
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: sizes.map((size) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(size),
                    selected: selectedSize == size,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedSize = size;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // قیمت
            Text(
              // 'Price: ${int.parse(widget.coffee.price) * quantity} تومان',
              'Price: ${widget.coffee.price * quantity} تومان',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),

            const SizedBox(height: 20),

            // تعداد
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Quantity:", style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text(quantity.toString(), style: const TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            // دکمه Add to Cart
            ElevatedButton(
              onPressed: addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: addedToCart
                    ? Colors.brown[200] // ✅ رنگ روشن بعد از کلیک
                    : Colors.brown[400],
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 32,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                addedToCart ? "Added!" : "Add to Cart", // ✅ متن تغییر کند
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

