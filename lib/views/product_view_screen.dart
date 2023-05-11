import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductViewScreen extends StatefulWidget {
  const ProductViewScreen({Key? key}) : super(key: key);

  @override
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Men's fit bag",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
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
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                  onPressed: () {},
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
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: 380,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.white),
            child: Image.network("https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"),
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
                    const Text("Men's Fit backpack bag", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("5,490\$", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
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
                            initialRating: 5,
                            maxRating: 5,
                            minRating: 0,
                            ignoreGestures: true,
                            allowHalfRating: true,
                            itemSize: 20,
                            itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            }),
                        const SizedBox(width: 5),
                        const Text("(20)")
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        "lorem ipsum dorem totem idk lorem ipsum dorem totem idk lorem ipsum dorem, totem idk lorem "
                        "ipsum dorem totem idk lorem ipsum dorem totem idk lorem ipsum dorem "),
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
                        ))
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
