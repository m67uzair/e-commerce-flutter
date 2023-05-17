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
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                  CustomTextFormField(label: "Full Name", controller: nameController),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    label: "Phone",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    label: "Email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    label: "Password",
                    controller: passwordController,
                    isPasswordField: true,
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
                  const SizedBox(height: 80),
                  const Text("Or Sign-up with a social account"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SquareTile(imagePath: 'assets/images/google.png', onTap: () {}),
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

class SquareTile extends StatelessWidget {
  final String imagePath;
  final void Function()? onTap;

  const SquareTile({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 64,
        width: 92,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 0.1, offset: Offset(1, 1))]),
        child: Image.asset(imagePath),
      ),
    );
  }
}

class CustomTextFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  TextInputType? keyboardType;
  bool isPasswordField;

  CustomTextFormField(
      {super.key, required this.label, required this.controller, this.isPasswordField = false, this.keyboardType});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Material(
        elevation: 0.8,
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.isPasswordField ? obscureText : false,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            label: Text(widget.label, style: const TextStyle(color: Colors.grey)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            border: InputBorder.none,
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText = obscureText ? false : true;
                      });
                    },
                    icon: obscureText ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
