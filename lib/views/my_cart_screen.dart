import 'dart:ffi';

import 'package:flutter/material.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({Key? key}) : super(key: key);

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("My Cart", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        actions: const [
          Icon(Icons.search, color: Colors.black),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Text(
                "My Bag",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: ListView(
                  children: const [
                    CartProductCard(),
                    SizedBox(height: 10),
                    CartProductCard(),
                    SizedBox(height: 10),
                    CartProductCard(),
                    SizedBox(height: 10),
                    CartProductCard(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Total Amount",
                    style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "153\$",
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(height: 40),
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
                      "CHECKOUT",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CartProductCard extends StatelessWidget {
  const CartProductCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          SizedBox(
            height: 122,
            width: 120,
            child: Image.asset(
              "assets/images/men's clothing model.PNG",
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "T-Shirt",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            RichText(
                                text: const TextSpan(
                                    text: "Color:",
                                    style: TextStyle(color: Colors.black45, fontSize: 16),
                                    children: [
                                  TextSpan(
                                      text: " Black",
                                      style: TextStyle(color: Colors.black, fontSize: 16),
                                      children: [
                                        TextSpan(
                                            text: "  Size:",
                                            style: TextStyle(color: Colors.black45, fontSize: 16),
                                            children: [
                                              TextSpan(text: " L", style: TextStyle(color: Colors.black, fontSize: 16))
                                            ])
                                      ]),
                                ])),
                          ]),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton.small(
                              onPressed: () {},
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey,
                              elevation: 3,
                              child: const Icon(Icons.remove)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              "1",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          FloatingActionButton.small(
                              onPressed: () {},
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey,
                              elevation: 3,
                              child: const Icon(Icons.add)),
                        ],
                      ),
                      const Text("51\$", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
