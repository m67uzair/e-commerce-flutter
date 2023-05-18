import 'package:ecommerce_app_flutter/Widgets/sign_up_and_login_widgets.dart';
import 'package:ecommerce_app_flutter/providers/auth_provider.dart';
import 'package:ecommerce_app_flutter/views/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app_flutter/main.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onClickRegister;

  const SignUpScreen({Key? key, required this.onClickRegister}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Sign Up",
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                        )),
                  ),
                  const SizedBox(height: 40),
                  CustomTextFormField(
                      label: "Full Name",
                      controller: nameController,
                      validator: ValidationBuilder().required().build()),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    label: "Phone",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: ValidationBuilder().phone().required().build(),
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    label: "Email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: ValidationBuilder().email().required().build(),
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                      label: "Password",
                      controller: passwordController,
                      isPasswordField: true,
                      validator: ValidationBuilder().minLength(6).required().build()),
                  CustomTextFormField(
                      label: "Confirm Password",
                      controller: confirmPasswordController,
                      isPasswordField: true,
                      validator: ValidationBuilder().minLength(6).required().add((value) {
                        if (value != passwordController.text) {
                          return "passwords do not match";
                        }
                        return null;
                      }).build()),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          const TextSpan(text: "Joined us before? ", style: TextStyle(color: Colors.black54)),
                          TextSpan(
                            text: "Login",
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(onClickLogin: () {}),
                                    ));
                              },
                          )
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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

                            bool isSignInSuccess = await authProvider.signUpWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                                displayName: nameController.text,
                                phoneNumber: phoneController.text);

                            if (isSignInSuccess) {
                              navigatorKey.currentState!.popUntil((route) => route.isFirst);
                            }
                          }
                        },
                        child: const Text(
                          "Sign-up",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  const Text("Or Sign-up with a social account"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SquareTile(
                          imagePath: 'assets/images/google.png',
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
                      SquareTile(
                        imagePath: "assets/images/facebook.png",
                        onTap: () {},
                      )
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
