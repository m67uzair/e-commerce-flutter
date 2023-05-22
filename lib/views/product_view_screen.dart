import 'dart:io';

import 'package:ecommerce_app_flutter/Controllers/cart_controller.dart';
import 'package:ecommerce_app_flutter/Models/products_model.dart';
import 'package:ecommerce_app_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

final productsModel = ProductsModel();

class ProductViewScreen extends StatefulWidget {
  final int productId;
  final String productTitle;
  final String productImageURL;
  final double productPrice;
  final String productDescription;
  final Rating productRating;

  const ProductViewScreen(
      {Key? key,
      required this.productImageURL,
      required this.productTitle,
      required this.productPrice,
      required this.productDescription,
      required this.productRating,
      required this.productId})
      : super(key: key);

  @override
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  late CartController cartProvider;
  late AuthProvider authProvider;
  late String loggedInUserId;

  List<XFile>? images = [];

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    loggedInUserId = authProvider.loggedInUserId.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartController>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          widget.productTitle,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20, overflow: TextOverflow.ellipsis),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.home, color: Color(0xffDB3022))),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll(Color(0xd7cb5500)),
                        padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 10, horizontal: 16)),
                        shape:
                            MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                    onPressed: () {},
                    child: const Text(
                      "Buy Now",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll(Color(0xffDB3022)),
                      padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 10, horizontal: 16)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                  onPressed: () async {
                    if (await cartProvider.isProductAlreadyInCart(widget.productId, loggedInUserId)) {
                      Fluttertoast.showToast(
                          msg: "Product is already in cart", timeInSecForIosWeb: 3, backgroundColor: Colors.black);
                    } else {
                      await cartProvider.addProductToCart(loggedInUserId, widget.productId, widget.productTitle,
                          widget.productImageURL, widget.productPrice);
                      cartProvider.setCartTotalPrice(widget.productPrice);
                      Fluttertoast.showToast(
                          msg: "Product added to cart", timeInSecForIosWeb: 3, backgroundColor: Colors.black);
                    }
                  },
                  child: const Text(
                    "Add to cart",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 380,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.white),
            child: Image.network(widget.productImageURL),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.productTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${widget.productPrice}\$",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 1)]),
                          child: const Icon(Icons.favorite_border),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        RatingBar.builder(
                            itemCount: 5,
                            initialRating: widget.productRating.rate!.toDouble(),
                            maxRating: widget.productRating.rate!.toDouble(),
                            minRating: widget.productRating.rate!.toDouble(),
                            ignoreGestures: true,
                            allowHalfRating: true,
                            itemSize: 20,
                            itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                            onRatingUpdate: (rating) {
                              // print(rating);
                            }),
                        const SizedBox(width: 5),
                        Text("(${widget.productRating.count!.toInt()})")
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(widget.productDescription),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration:
                          BoxDecoration(color: const Color(0xFFF5F2F0), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.fire_truck,
                                color: Colors.blueGrey[800],
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "  Standard delivery  ",
                                    style: TextStyle(
                                        color: Colors.blueGrey[800], fontSize: 18, fontWeight: FontWeight.w500),
                                    children: [
                                      TextSpan(
                                          text: "16-20 days",
                                          style: TextStyle(color: Colors.blueGrey[700], fontSize: 15))
                                    ]),
                              )
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios_outlined, color: Colors.blueGrey[800])
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("8 Reviews", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        showModalBottomSheet(
                          backgroundColor: const Color(0xEFF9F9F9),
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                          builder: (context) => ReviewModelSheet(images: images),
                        );
                      });
                    },
                    icon: const Icon(
                      Icons.edit,
                    ),
                    label: const Text("Write a "
                        "review"),
                    style: const ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.black)),
                  ),
                ],
              )),
          Container(
            width: MediaQuery.of(context).size.width,
            // height: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                children: const [
                  UserReview(),
                  SizedBox(height: 10),
                  UserReview(),
                  SizedBox(height: 10),
                  UserReview(),
                  SizedBox(height: 10),
                  UserReview(),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class ReviewModelSheet extends StatelessWidget {
  const ReviewModelSheet({
    super.key,
    required this.images,
  });

  final List<XFile>? images;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setModalState) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.80,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text("Write a review",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 10),
            RatingBar.builder(
                minRating: 0,
                maxRating: 5,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 5),
                itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {}),
            const SizedBox(height: 30),
            const Text("Please Share your opinion",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "Write a review", border: OutlineInputBorder()),
                maxLines: 10,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 120,
                width: MediaQuery.of(context).size.width * 80,
                child: ListView.builder(
                  itemCount: images!.isEmpty ? 1 : images!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return images!.isEmpty || index == 0
                        ? GestureDetector(
                            onTap: () async {
                              ImagePicker picker = ImagePicker();
                              final List<XFile> pickedImages = await picker.pickMultiImage();
                              if (pickedImages.isNotEmpty) {
                                images!.addAll(pickedImages);
                              }
                              setModalState(() {});
                            },
                            child: Container(
                              height: 120,
                              width: 120,
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 50,
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Add a photo",
                                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(image: FileImage(File(images![index].path)))),
                          );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserReview extends StatelessWidget {
  const UserReview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("John Doe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.star, color: Colors.amber, size: 18),
                Icon(Icons.star, color: Colors.amber, size: 18),
                Icon(Icons.star, color: Colors.amber, size: 18),
                Icon(Icons.star, color: Colors.amber, size: 18),
                Icon(Icons.star_border, size: 18),
              ],
            ),
            const Text(
              "August 12, 2022",
              style: TextStyle(color: Color(0xff9B9B9B)),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Text(
          "lorem ipsum dorm totem idk lorem ipsum dorm totem"
          "idk lorem ipsum dorm totem idk lorem ipsum dorm "
          "totem idk lorem ipsum dorm totem idk",
          style: TextStyle(color: Color(0xFF222222), fontSize: 16),
        )
      ],
    );
  }
}
