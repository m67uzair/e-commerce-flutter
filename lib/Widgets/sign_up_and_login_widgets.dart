import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final bool isPasswordField;

  const CustomTextFormField(
      {super.key,
      required this.label,
      required this.controller,
      this.isPasswordField = false,
      this.keyboardType,
      required this.validator});

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
          validator: widget.validator,
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
