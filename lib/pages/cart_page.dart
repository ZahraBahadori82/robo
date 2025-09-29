
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robo/models/coffee_shop.dart';
import '../components/coffee_tile.dart';
import '../const.dart';
import '../models/coffee.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/order_service.dart';
import 'order_confirmation_page.dart'; // 👈 Import the new confirmation page

class CartPage extends StatefulWidget {
  final String? tableId;
  final String? restaurantId;

  const CartPage({
    super.key,
    this.tableId,
    this.restaurantId,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isNavigating = false; // 👈 Changed from _isSubmitting to _isNavigating

  // Remove item from cart
  void removedFromCart(Coffee coffee) {
    Provider.of<CoffeeShop>(context, listen: false).removeItemFromCart(coffee);
  }

  // 👈 Modified handlePay function - now navigates to confirmation page
  void handlePay() async {
    if (_isNavigating) return; // Prevent double navigation

    setState(() {
      _isNavigating = true;
    });

    try {
      // Get cart items
      final cartItems = Provider.of<CoffeeShop>(context, listen: false).userCart;

      if (cartItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your cart is empty!'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {
          _isNavigating = false;
        });
        return;
      }

      // Calculate total price
      int totalPrice = cartItems.fold<int>(0, (sum, item) => sum + item.price * item.quantity);

      // 👈 Navigate to confirmation page instead of submitting directly
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationPage(
            tableId: widget.tableId,
            restaurantId: widget.restaurantId,
            cartItems: cartItems,
            totalPrice: totalPrice,
          ),
        ),
      );

      // 👈 After returning from confirmation page, refresh the cart display
      setState(() {});

    } catch (e) {
      print('❌ Error in handlePay: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Could not proceed to confirmation. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isNavigating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeShop>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text('Cart - Table ${widget.tableId ?? "Unknown"}'),
          backgroundColor: Colors.brown[400],
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                // 👈 Improved header with better formatting
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.brown[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.brown[200]!),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart, color: Colors.brown[600], size: 28),
                          const SizedBox(width: 10),
                          Text(
                            'Table ${widget.tableId ?? "Unknown"}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.brown[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Total: ${value.userCart.fold<int>(0, (sum, item) => sum + item.price * item.quantity)} تومان',

                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // List of cart items
                Expanded(
                  child: value.userCart.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Add some items to get started!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: value.userCart.length,
                    itemBuilder: (context, index) {
                      Coffee eachCoffee = value.userCart[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CoffeeTile(
                          coffee: eachCoffee,
                          onPressed: () => removedFromCart(eachCoffee),
                          icon: const Icon(Icons.delete, color: Colors.black26),
                          showMultiplication: true,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // 👈 Enhanced Pay button with better design
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: (_isNavigating || value.userCart.isEmpty) ? null : handlePay,
                    icon: _isNavigating
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(Icons.payment, size: 28),
                    label: Text(
                      _isNavigating ? "Processing..." : "Proceed to Payment",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (_isNavigating || value.userCart.isEmpty)
                          ? Colors.grey
                          : Colors.brown[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),

                // 👈 Added helpful text below button
                if (value.userCart.isNotEmpty) ...[
                  const SizedBox(height: 15),
                  Text(
                    '💡 You\'ll have 15 seconds to review your order',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}