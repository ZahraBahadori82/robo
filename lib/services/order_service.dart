// services/order_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coffee.dart';

Future<bool> submitOrder(
    List<Coffee> cartItems,
    int tableId,
    {String? tableLocation, String? restaurantId}
    ) async {
  final url = Uri.parse('http://192.168.137.1:8888/api/orders/submit');

  // Calculate total price - convert "50t" format to numeric
  double totalPrice = 0.0;
  List<Map<String, dynamic>> items = [];

  for (Coffee item in cartItems) {
    // Remove 't' from price and convert to double
    // String priceStr = item.price.replaceAll('t', '');
    int price = item.price; // یا اگر می‌خوای رشته بفرستی:
    String priceStr = item.price.toString();
    // double price = double.tryParse(priceStr) ?? 0.0;
    totalPrice += price;

    items.add({
      'name': item.name,
      'price': price,  // Send as number, not string
    });
  }

  final body = {
    'tableId': tableId,  // Match your server's expected field name
    'tableLocation': tableLocation ?? 'A${tableId}',  // Default location
    'restaurantId': restaurantId ?? 'myRestaurant',   // Default restaurant
    'items': items,
    'totalPrice': totalPrice,  // Match your server's expected field name
  };

  print('🔍 Sending order data: ${json.encode(body)}');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    print('📡 Response status: ${response.statusCode}');
    print('📡 Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        print("✅ Order submitted successfully");
        return true;
      } else {
        print("❌ Server returned error: ${responseData['message']}");
        return false;
      }
    } else {
      print("❌ HTTP error: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("❌ Network error: $e");
    return false;
  }
}