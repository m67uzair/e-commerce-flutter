import 'package:ecommerce_app_flutter/views/home_screen.dart';
import 'package:ecommerce_app_flutter/views/product_view_screen.dart';
import 'package:ecommerce_app_flutter/views/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/login_screen.dart';

void main() {
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "E-commerce App flutter",
      debugShowCheckedModeBanner: false,
      home: const ProductViewScreen(),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xffF9F9F9),
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color(0xffF9F9F9),
              )),
          scaffoldBackgroundColor: const Color(0xffF9F9F9)),
    );
  }
}
