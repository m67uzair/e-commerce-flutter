import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app_flutter/Controllers/favorites_controller.dart';
import 'package:ecommerce_app_flutter/views/product_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../Models/products_model.dart';
import '../Controllers/products_controller.dart';

final productsApi = ProductsController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: const Icon(Icons.menu_sharp),
      //   title: const Text(
      //     "Hello Word!",
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined))],
      // ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 220,
              child: CarouselSlider(items: const [
                ItemCarousel(
                  title: "Men's Clothing",
                  imagePath: "assets/images/men's clothing model.PNG",
                ),
                ItemCarousel(title: "Women's Clothing", imagePath: "assets/images/women1.png"),
                ItemCarousel(title: "Electronics", imagePath: "assets/images/electronics.jpeg"),
                ItemCarousel(title: "jewelery", imagePath: "assets/images/jewelery.jpeg"),
              ], options: CarouselOptions(autoPlay: true, viewportFraction: 1, height: 400)),
            ),
            const SizedBox(height: 30),
            ProductList(
              productsListTitle: "Men's Clothing",
              onViewAllPressed: () {},
            ),
            const SizedBox(height: 50),
            ProductList(
              productsListTitle: "Women's Clothing",
              onViewAllPressed: () {},
            ),
            const SizedBox(height: 50),
            ProductList(
              productsListTitle: "Electronics",
              onViewAllPressed: () {},
            ),
            const SizedBox(height: 50),
            ProductList(
              productsListTitle: "jewelery",
              onViewAllPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  final String productsListTitle;
  final Function onViewAllPressed;

  const ProductList({super.key, required this.productsListTitle, required this.onViewAllPressed});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    print("whole  built");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.productsListTitle,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 30)),
            TextButton(
                onPressed: widget.onViewAllPressed(),
                child: const Text(
                  "View All",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ))
          ],
        ),
        SizedBox(
          height: 280,
          child: FutureBuilder(
            future: productsApi.getProductsData(widget.productsListTitle.toLowerCase()),
            builder: (context, AsyncSnapshot<List<ProductsModel>> snapshot) {
              return ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  print("listview built");
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return snapshot.data!.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductViewScreen(
                                            productId: snapshot.data![index].id!.toInt(),
                                            productImageURL: snapshot.data![index].image.toString(),
                                            productTitle: snapshot.data![index].title.toString(),
                                            productPrice: snapshot.data![index].price!.toDouble(),
                                            productDescription: snapshot.data![index].description.toString(),
                                            productRating: snapshot.data![index].rating!,
                                          )));
                              setState(() {});
                            },
                            child: ProductCard(
                              productImageURL: snapshot.data![index].image.toString(),
                              productTitle: snapshot.data![index].title.toString(),
                              productRating: snapshot.data![index].rating!.rate!.toDouble(),
                              productRatingCount: snapshot.data![index].rating!.count!.toInt(),
                              productPrice: snapshot.data![index].price!.toDouble(),
                              productId: snapshot.data![index].id!.toInt(),
                            ),
                          )
                        : Container();
                  }
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}

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
            elevation: 0,
            color: Colors.transparent,
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

class ItemCarousel extends StatelessWidget {
  final String title;
  final String imagePath;

  const ItemCarousel({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          bottom: 10,
          left: 5,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Colors.white),
          ),
        )
      ],
    );
  }
}
