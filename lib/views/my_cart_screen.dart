import 'package:flutter/material.dart';

import '../Controllers/products_controller.dart';

final productsController = ProductsController();

class MyCartScreen extends StatefulWidget {
  final productsList = productsController.getProductsInCart();

  MyCartScreen({Key? key}) : super(key: key);

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  @override
  Widget build(BuildContext context) {
    // print(widget.productsList);
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
                "My Cart",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: ListView.builder(
                  itemCount: widget.productsList.length,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (context, index) => CartProductCard(
                      productPrice: widget.productsList[index].price.toString(),
                      productImageURL: widget.productsList[index].image.toString(),
                      productTitle: widget.productsList[index].title.toString(),
                      productId: widget.productsList[index].id!.toInt()),
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
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(Color(0xffDB3022)),
                          padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16)),
                          shape:
                              MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)))),
                      onPressed: () {},
                      child: const Text(
                        "CHECKOUT",
                        style: TextStyle(fontSize: 17),
                      ),
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

class CartProductCard extends StatefulWidget {
  final String productImageURL;
  final String productTitle;
  final int productId;

  int count = 1;
  String productPrice;
  String originalPrice = '';

  CartProductCard({
    super.key,
    required this.productPrice,
    required this.productImageURL,
    required this.productTitle,
    required this.productId,
  });

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  @override
  void initState() {
    widget.originalPrice = widget.productPrice;
    super.initState();
  }

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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton.small(
                              onPressed: widget.count == 1
                                  ? null
                                  : () {
                                      setState(() {
                                        widget.count--;
                                        widget.productPrice =
                                            (int.parse(widget.productPrice) - int.parse(widget.originalPrice))
                                                .toString();
                                        print(widget.productPrice);
                                      });
                                    },
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey,
                              elevation: 3,
                              child: const Icon(Icons.remove)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              "${widget.count}",
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          FloatingActionButton.small(
                              onPressed: () {
                                setState(() {
                                  widget.count++;
                                  widget.productPrice =
                                      (int.parse(widget.productPrice) + int.parse(widget.originalPrice)).toString();
                                  print(widget.productPrice);
                                });
                              },
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey,
                              elevation: 3,
                              child: const Icon(Icons.add)),
                        ],
                      ),
                      Text("${widget.productPrice}\$",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
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
