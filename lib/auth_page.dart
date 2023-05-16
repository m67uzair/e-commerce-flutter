import 'package:ecommerce_app_flutter/views/login_screen.dart';
import 'package:ecommerce_app_flutter/views/sign_up_screen.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = false;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginScreen(
          onClickLogin: toggle,
        )
      : SignUpScreen(
          onClickRegister: toggle,
        );

  void toggle() => setState(() => isLogin = !isLogin);
}
