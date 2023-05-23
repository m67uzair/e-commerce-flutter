import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class FavoriteProductCard extends StatefulWidget {
  final String productImageURL;
  final String productTitle;
  final int productId;
  final int count;
  double productPrice;

  FavoriteProductCard({
    super.key,
    required this.productPrice,
    required this.productImageURL,
    required this.productTitle,
    required this.productId,
    required this.count,
  });

  @override
  State<FavoriteProductCard> createState() => _FavoriteProductCardState();
}

class _FavoriteProductCardState extends State<FavoriteProductCard> {
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
                                        onPressed: widget.count == 1
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
                                        onPressed: () async {
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
