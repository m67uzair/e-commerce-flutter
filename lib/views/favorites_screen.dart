import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_flutter/Controllers/favorites_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/favorites_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

late FavoritesController favoritesProvider;

class _FavoritesScreenState extends State<FavoritesScreen> {
  void initState() {
    favoritesProvider = Provider.of<FavoritesController>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Icon(Icons.search, color: Colors.black),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: favoritesProvider.getProductsInCart(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          FavoritesModel favoriteProduct = FavoritesModel.fromDocument(snapshot.data!.docs[index]);
                          return FavoriteProductCard(
                              productPrice: favoriteProduct.productPrice,
                              productImageURL: favoriteProduct.productImageURL,
                              productTitle: favoriteProduct.productTitle,
                              productId: favoriteProduct.productId);
                        },
                      );
                    } else {
                      return const Text("No products made favorite yet");
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteProductCard extends StatefulWidget {
  final String productImageURL;
  final String productTitle;
  final int productId;
  double productPrice;

  FavoriteProductCard({
    super.key,
    required this.productPrice,
    required this.productImageURL,
    required this.productTitle,
    required this.productId,
  });

  @override
  State<FavoriteProductCard> createState() => _FavoriteProductCardState();
}

class _FavoriteProductCardState extends State<FavoriteProductCard> {
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
                          icon: const Icon(Icons.close_outlined),
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
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            Icon(Icons.star_border, size: 18),
                          ],
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
