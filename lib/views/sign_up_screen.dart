import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onClickRegister;

  const SignUpScreen({Key? key, required this.onClickRegister}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Sign Up",
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                        )),
                  ),
                  const SizedBox(height: 73),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Material(
                      elevation: 0.8,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            label: Text("Full Name", style: TextStyle(color: Colors.grey)),
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Material(
                      elevation: 0.8,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            label: Text("Phone", style: TextStyle(color: Colors.grey)),
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Material(
                      elevation: 0.8,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            label: Text("Email", style: TextStyle(color: Colors.grey)),
                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Material(
                      elevation: 0.8,
                      child: TextFormField(
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                          border: InputBorder.none,
                          label: const Text("password", style: TextStyle(color: Colors.grey)),
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
                        onPressed: () {},
                        child: const Text(
                          "Sign-up",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  const Text("Or Sign-up with a social account"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 64,
                        width: 92,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 0.1, offset: Offset(-1, 1))]),
                        child: Image.asset('assets/images/google.png'),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 64,
                        width: 92,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 0.1, offset: Offset(-1, 1))],
                        ),
                        child: Image.asset('assets/images/facebook.png'),
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
