
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'models/coffee_shop.dart';
import 'package:robo/pages/splash_page.dart';
import 'pages/home_page.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create: (context) => CoffeeShop(),
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      ),
    );
  }
}
// Define your routes for QR code functionality
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    // Default route - shows splash page
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
    ),

    // Route for normal navigation from splash to home
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),

    // Route for QR code scanning - goes directly to home with table info
    GoRoute(
      path: '/table/:tableId',
      builder: (BuildContext context, GoRouterState state) {
        final tableId = state.pathParameters['tableId']!;
        final restaurantId = state.uri.queryParameters['restaurant_id'];

        return HomePage(
          tableId: tableId,
          restaurantId: restaurantId,
        );
      },
    ),
  ],
);