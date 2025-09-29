class Coffee {
  final int? id;
  final String name;
  final int price; // قیمت به تومان به صورت عدد صحیح
  final String imagePath;
  int quantity;
  String size;

  Coffee({
    this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
    this.size = 'M',
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'price': price,
      'imagePath': imagePath,
      'quantity': quantity,
      'size': size,
    };
  }

  factory Coffee.fromJson(Map<String, dynamic> json) {
    // اگر API/دیتابیس قیمت رو به صورت رشته فرستاده بود، اینجا هندل می‌کنیم
    int parsedPrice;
    if (json['price'] is String) {
      parsedPrice = int.tryParse((json['price'] as String).replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    } else if (json['price'] is num) {
      parsedPrice = (json['price'] as num).toInt();
    } else {
      parsedPrice = 0;
    }

    return Coffee(
      id: json['id'],
      name: json['name'] ?? '',
      price: parsedPrice,
      imagePath: json['imagePath'] ?? '',
      quantity: json['quantity'] ?? 1,
      size: json['size'] ?? 'M',
    );
  }
}
