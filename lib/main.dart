import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_flutter/Controllers/cart_controller.dart';
import 'package:ecommerce_app_flutter/auth_page.dart';
import 'package:ecommerce_app_flutter/providers/auth_provider.dart';
import 'package:ecommerce_app_flutter/views/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(ECommerceApp(prefs: prefs));
}

final navigatorKey = GlobalKey<NavigatorState>();

class ECommerceApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  ECommerceApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: (_) =>
                AuthProvider(googleSignIn: GoogleSignIn(), firebaseAuth: FirebaseAuth.instance, prefs: prefs)),
        ChangeNotifierProvider<CartController>(
          create: (_) => CartController(prefs: prefs, firebaseFirestore: firebaseFirestore),
        )
      ],
      child: MaterialApp(
        title: "E-commerce App flutter",
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return const MainScreen();
            } else {
              return const AuthPage();
            }
          },
        ),
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xffF9F9F9),
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Color(0xffF9F9F9),
                )),
            scaffoldBackgroundColor: const Color(0xffF9F9F9)),
      ),
    );
  }
}
