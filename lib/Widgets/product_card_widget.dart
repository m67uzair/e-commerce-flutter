import 'package:ecommerce_app_flutter/Controllers/favorites_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final String productTitle;
  final String productImageURL;
  final int productRatingCount;
  final double productRating;
  final double productPrice;
  final int productId;

  const ProductCard(
      {Key? key,
      required this.productTitle,
      required this.productImageURL,
      required this.productRating,
      required this.productRatingCount,
      required this.productPrice,
      required this.productId})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Stack(
        children: [
          Card(
            elevation: 1,
            shadowColor: Colors.black12,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(widget.productImageURL),
                  ),
                ),
                Row(
                  children: [
                    RatingBar.builder(
                        itemCount: 5,
                        initialRating: widget.productRating,
                        maxRating: widget.productRating,
                        minRating: widget.productRating,
                        ignoreGestures: true,
                        allowHalfRating: true,
                        itemSize: 22,
                        itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                        onRatingUpdate: (rating) {
                          // print(rating);
                        }),
                    const SizedBox(width: 5),
                    Text('(${widget.productRatingCount})')
                  ],
                ),
                Text(
                  widget.productTitle,
                  maxLines: 2,
                  style: const TextStyle(
                      color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.productPrice}\$",
                      style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Consumer<FavoritesController>(
                        builder: (context, favoritesProvider, child) => FutureBuilder(
                              future: favoritesProvider.isProductAlreadyInFavorites(widget.productId),
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  final isFavorite = snapshot.data;
                                  return IconButton(
                                    iconSize: 28,
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: () {
                                      if (isFavorite) {
                                        favoritesProvider.removeProductFromFavorites(widget.productId);
                                      } else {
                                        favoritesProvider.addProductToFavorites(widget.productId, widget.productTitle,
                                            widget.productImageURL, widget.productPrice);
                                      }
                                    },
                                  );
                                } else {
                                  return const Icon(Icons.favorite_border);
                                }
                              },
                            )),
                  ],
                )
              ],
            ),
          ),
          // Positioned(
          //   bottom: -2,
          //   right: -1,
          //   child: Consumer<FavoritesController>(
          //       builder: (context, favoritesProvider, child) => FutureBuilder(
          //             future: favoritesProvider.isProductAlreadyInFavorites(widget.productId),
          //             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //               if (snapshot.hasData) {
          //                 final isFavorite = snapshot.data;
          //                 return IconButton(
          //                   iconSize: 28,
          //                   icon: Icon(
          //                     isFavorite ? Icons.favorite : Icons.favorite_border,
          //                     color: isFavorite ? Colors.red : Colors.grey,
          //                   ),
          //                   onPressed: () {
          //                     if (isFavorite) {
          //                       favoritesProvider.removeProductFromFavorites(widget.productId);
          //                     } else {
          //                       favoritesProvider.addProductToFavorites(widget.productId, widget.productTitle,
          //                           widget.productImageURL, widget.productPrice);
          //                     }
          //                   },
          //                 );
          //               } else {
          //                 return const Icon(Icons.favorite_border);
          //               }
          //             },
          //           )),
          // )
        ],
      ),
    );
  }
}
