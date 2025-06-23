import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trade_021/controller/orderController.dart';
import 'package:trade_021/screens/open_orders_screen.dart';
// --- MAIN FUNCTION ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use ChangeNotifierProvider to make the OrderController available to the widget tree.
    return ChangeNotifierProvider(
      create: (_) => OrderController(),
      child: MaterialApp(
        title: 'Flutter Orders Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF7F7F7),
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        ),
        home: const OrdersScreen(),
      ),
    );
  }
}