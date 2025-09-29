import 'package:flutter/material.dart';
import 'package:robo/models/coffee.dart';


// class CoffeeTile extends StatelessWidget{
//
//   final Coffee coffee;
//   void Function()? onPressed;
//   final Widget icon;
//   CoffeeTile({super.key, required this.coffee, required this.onPressed , required this.icon});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(color: Colors.grey[200] , borderRadius: BorderRadius.circular(12)),
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
//       child: ListTile(
//         leading: Image.asset(coffee.imagePath),
//         title: Text('${coffee.name} (${coffee.quantity}x)'),
//         subtitle: Text('${coffee.price} × ${coffee.quantity} = ${int.parse(coffee.price) * coffee.quantity}'),
//         trailing: IconButton(
//             icon: icon,
//             onPressed: onPressed,
//         ),
//       ),
//     );
//   }
// }
class CoffeeTile extends StatelessWidget {
  final Coffee coffee;
  final void Function()? onPressed;
  final Widget icon;
  final bool showMultiplication; // 👈 New optional flag

  const CoffeeTile({
    super.key,
    required this.coffee,
    required this.onPressed,
    required this.icon,
    this.showMultiplication = true, // default = true
  });

  @override
  Widget build(BuildContext context) {
    final int basePrice = coffee.price ?? 0;
    final int total = basePrice * coffee.quantity;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      child: ListTile(
        leading: Image.asset(coffee.imagePath),
        title: Text(coffee.name),
        subtitle: showMultiplication
            ? Text('$basePrice × ${coffee.quantity} = $total تومان')
            : Text('$basePrice تومان'), // 👈 Base price only
        trailing: IconButton(
          icon: icon,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
