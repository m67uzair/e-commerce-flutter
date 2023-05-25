import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.white),
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "All Products",
          style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w700),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.search, color: Colors.black, size: 25),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CategoryButton(categoryTitle: "Men's Clothing", onPressed: (){}),
                CategoryButton(categoryTitle: "Women's Clothing", onPressed: (){}),
                CategoryButton(categoryTitle: "Jewelery", onPressed: (){}),
                CategoryButton(categoryTitle: "Electronics", onPressed: (){}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String categoryTitle;
  final void Function() onPressed;

  const CategoryButton({
    super.key,
    required this.categoryTitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Color(0xff222222)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child: Text(categoryTitle),
      ),
    );
  }
}
