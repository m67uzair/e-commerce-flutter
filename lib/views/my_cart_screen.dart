import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_flutter/Controllers/cart_controller.dart';
import 'package:ecommerce_app_flutter/Models/cart_model.dart';
import 'package:ecommerce_app_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controllers/products_controller.dart';

late CartController cartProvider;
late AuthProvider authProvider;
double updatedPrice = 0.0;

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({Key? key}) : super(key: key);

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  List productsList = [];

  @override
  void initState() {
    cartProvider = Provider.of<CartController>(context, listen: false);
    authProvider = context.read<AuthProvider>();
    getCartTotalPrice();
    super.initState();
  }

  getCartTotalPrice() async {
    await cartProvider.getCartTotalPrice();
  }

  @override
  Widget build(BuildContext context) {
    print("build called");
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white70,
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
              // const SizedBox(height: 20),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: cartProvider.getProductsInCart(authProvider.loggedInUserId.toString(), 10),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          productsList = snapshot.data!.docs;
                          if (productsList.isNotEmpty) {
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                itemBuilder: (context, index) {
                                  print("index: $index");
                                  CartModel cartModel = CartModel.fromDocument(snapshot.data!.docs[index]);
                                  return CartProductCard(
                                      productPrice: cartModel.productPrice,
                                      productImageURL: cartModel.productImageURL,
                                      productTitle: cartModel.productTitle,
                                      productId: cartModel.productId,
                                      count: cartModel.count);
                                });
                          } else {
                            return const Center(child: Text("No products in cart yet"));
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.redAccent,
                            ),
                          );
                        }
                      })),
              const SizedBox(height: 20),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Amount",
                      style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Consumer<CartController>(
                      builder: (context, value, child) => value.isLoading
                          ? const Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator()))
                          : Text(
                              "${value.cartTotalPrice.toStringAsFixed(2)}\$",
                              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                    )
                  ],
                ),
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
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)))),
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
  final int count;
  double productPrice;

  CartProductCard({
    super.key,
    required this.productPrice,
    required this.productImageURL,
    required this.productTitle,
    required this.productId,
    required this.count,
  });

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            SizedBox(
              height: 122,
              width: 120,
              child: Image.network(
                widget.productImageURL,
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
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.productTitle.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                                                  TextSpan(
                                                      text: " L", style: TextStyle(color: Colors.black, fontSize: 16))
                                                ])
                                          ]),
                                    ])),
                              ]),
                        ),
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
                        Consumer<CartController>(
                          builder: (context, cartObject, child) => cartObject.isLoading
                              ? const Center(
                                  child: SizedBox(
                                    height: 50,
                                    width: 100,
                                    child: Center(child: CircularProgressIndicator()),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FloatingActionButton.small(
                                        heroTag: "decreaseBtn${widget.count}",
                                        onPressed: widget.count == 1 || cartObject.isLoading
                                            ? null
                                            : () async {
                                                updatedPrice = (widget.productPrice / widget.count);

                                                widget.productPrice -= updatedPrice;

                                                await cartProvider.setCartTotalPrice(-updatedPrice);

                                                // print(-(widget.productPrice/widget.count));

                                                await cartProvider.updateCartProductCountAndPrice(
                                                    authProvider.loggedInUserId.toString(),
                                                    widget.productId,
                                                    widget.count - 1,
                                                    widget.productPrice);
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
                                        heroTag: "increaseBtn${widget.count}",
                                        onPressed: cartObject.isLoading
                                            ? null
                                            : () async {
                                                updatedPrice = (widget.productPrice / widget.count);

                                                widget.productPrice += updatedPrice;

                                                await cartProvider.setCartTotalPrice(updatedPrice);

                                                await cartProvider.updateCartProductCountAndPrice(
                                                    authProvider.loggedInUserId.toString(),
                                                    widget.productId,
                                                    widget.count + 1,
                                                    widget.productPrice);
                                              },
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.grey,
                                        elevation: 3,
                                        child: const Icon(Icons.add)),
                                  ],
                                ),
                        ),
                        Text("${widget.productPrice.toStringAsFixed(2)}\$",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
