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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                              // print(rating);
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
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                          builder: (context) => Container(
                            height: MediaQuery.of(context).size.height * 0.80,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
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
                                    decoration:
                                        const InputDecoration(
                                            hintText: "Write a review", border: OutlineInputBorder()
                                        ),
                                    maxLines: 10,
                                  ),
                                ),

                              ],
                            ),
                          ),
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
          "lorem ipsum dorm totem idk lorem ipsum dorem totem"
          "idklorem ipsum dorem totem idk lorem ipsum dorem "
          "totem idk lorem ipsum dorem totem idk",
          style: TextStyle(color: Color(0xFF222222), fontSize: 16),
        )
      ],
    );
  }
}
