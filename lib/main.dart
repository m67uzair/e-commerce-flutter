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
      home: const LoginScreen(),
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
