import 'package:ecommerce_app_flutter/main.dart';
import 'package:ecommerce_app_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
            style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black)),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
                barrierDismissible: false,
              );
              await Provider.of<AuthProvider>(context,listen: false).signOut();
              navigatorKey.currentState!.popUntil((route) => route.isFirst);
            },
            child: const Text("log out"))
      ],
    );
  }
}
