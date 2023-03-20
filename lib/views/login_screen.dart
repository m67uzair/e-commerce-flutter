import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const Icon(Icons.arrow_back_ios_new_sharp, color: Color(0xff222222)),
        leadingWidth: 50,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                    ),
                  ),
                  const SizedBox(height: 73),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Material(
                      elevation: 1,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            label: Text("Email"),
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Material(
                      elevation: 1,
                      child: TextFormField(
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                          border: InputBorder.none,
                          label: const Text("password"),
                          suffixIcon: IconButton(
                            onPressed: () {
                              obscureText = obscureText ? false : true;
                            },
                            icon: obscureText ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "Forgot your password?",
                            style: TextStyle(color: Color(0xff222222)),
                          ),
                          Icon(Icons.arrow_forward_sharp)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
