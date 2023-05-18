import 'package:ecommerce_app_flutter/Widgets/sign_up_and_login_widgets.dart';
import 'package:ecommerce_app_flutter/main.dart';
import 'package:ecommerce_app_flutter/providers/auth_provider.dart';
import 'package:ecommerce_app_flutter/views/sign_up_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onClickLogin;

  const LoginScreen({Key? key, required this.onClickLogin}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Login",
                        style: TextStyle(fontFamily: "Metropolis", fontWeight: FontWeight.bold, fontSize: 36)),
                  ),
                  const SizedBox(height: 73),
                  CustomTextFormField(
                      label: "Email", controller: emailController, validator: ValidationBuilder().email().build()),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                      label: "Password",
                      controller: passwordController,
                      validator: ValidationBuilder().required().build()),
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
                          Icon(
                            Icons.arrow_forward_sharp,
                            color: Color(0xffDB3022),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          const TextSpan(text: "Don't have an account? ", style: TextStyle(color: Colors.black54)),
                          TextSpan(
                            text: "Sign up",
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpScreen(onClickRegister: () {}),
                                    ));
                              },
                          )
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll(Color(0xffDB3022)),
                            padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)))),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              barrierDismissible: false,
                            );
                            bool isLoginSuccess = await authProvider.loginWithEmailAndPassword(
                                email: emailController.text, password: passwordController.text);
                            if (isLoginSuccess) {
                              navigatorKey.currentState!.popUntil((route) => route.isFirst);
                            }
                          }
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  const Text("Or login with a social account"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SquareTile(
                          imagePath: "assets/images/google.png",
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              barrierDismissible: false,
                            );
                            bool isSignInSuccess = await authProvider.signInWithGoogle();
                            if (isSignInSuccess) {
                              navigatorKey.currentState!.popUntil((route) => route.isFirst);
                            }
                          }),
                      const SizedBox(width: 8),
                      SquareTile(imagePath: "assets/images/facebook.png", onTap: () {}),
                    ],
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
