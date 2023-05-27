import 'package:ecommerce_app_flutter/Controllers/products_controller.dart';
import 'package:ecommerce_app_flutter/Models/products_model.dart';
import 'package:ecommerce_app_flutter/Widgets/product_card_widget.dart';
import 'package:ecommerce_app_flutter/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

List<ProductsModel> productsList = [];

class ShopScreen extends StatefulWidget {
  int passedIndex;

  ShopScreen({Key? key, this.passedIndex = -1}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String appbarTitle = "All Products";
  bool isList = false;
  bool isLoading = false;
  int selectedIndex = -1;
  late ProductsController productApi;

  @override
  void initState() {
    print("passed index${widget.passedIndex}");
    productApi = Provider.of<ProductsController>(context, listen: false);
    productsList = productApi.fetchProductsInCategory();
    setSelectedIndex(widget.passedIndex);
    super.initState();
  }

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void setSelectedIndex(int index) {
    print("passed index ${widget.passedIndex} selected index $selectedIndex");
    if (selectedIndex == index) {
      toggleLoading();
      selectedIndex = -1;
      productsList = productApi.fetchProductsInCategory();
      appbarTitle = "All Products";
      toggleLoading();
    } else {
      toggleLoading();
      selectedIndex = index;
      String category = productApi.categories[selectedIndex];
      productsList = productApi.fetchProductsInCategory(category: category);
      appbarTitle = "${category[0].toUpperCase()}${category.substring(1)} products";
      toggleLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("shope screen");
    return isLoading
        ? const CircularProgressIndicator(color: Colors.redAccent)
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.white),
              elevation: 1,
              shadowColor: Colors.black45,
              centerTitle: true,
              title: Text(
                appbarTitle,
                style: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w700),
              ),
              actions: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.search, color: Colors.black, size: 25),
                ),
              ],
            ),
            body: Consumer<ProductsController>(
                builder: (context, value, child) => value.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
                    : Column(
                        children: [
                          // const SizedBox(height: 10),
                          Material(
                            elevation: 2,
                            shadowColor: Colors.black45,
                            child: Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  height: 50,
                                  child: ListView.builder(
                                    itemCount: productApi.categories.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        child: SizedBox(
                                          height: 45,
                                          child: CategoryButton(
                                            categoryTitle: productApi.categories[index],
                                            onPressed: () {
                                              setSelectedIndex(index);
                                            },
                                            isSelected: index == selectedIndex ? true : false,
                                          ),
                                        ),
                                      );
                                    },
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  color: const Color(0xfff9f9f9),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton.icon(
                                          onPressed: () {},
                                          icon: const Icon(Icons.filter_list_rounded, color: Color(0xff222222)),
                                          label: const Text(
                                            "Filters",
                                            style: TextStyle(color: Color(0xff222222)),
                                          )),
                                      Container(
                                        child: Row(children: const [
                                          Icon(Icons.swap_vert),
                                          SizedBox(width: 5),
                                          Text(
                                            "Price lowest to highest",
                                            style: TextStyle(color: Color(0xff222222)),
                                          )
                                        ]),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isList = !isList;
                                          });
                                        },
                                        icon: isList
                                            ? const Icon(Icons.view_list, color: Color(0xff222222))
                                            : const Icon(Icons.grid_view, color: Color(0xff222222)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: isList
                                ? ListView.builder(
                                    itemCount: productsList.length,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        height: 270,
                                        width: 50,
                                        child: ProductCard(
                                            productTitle: productsList[index].title.toString(),
                                            productImageURL: productsList[index].image.toString(),
                                            productRating: productsList[index].rating!.rate!.toDouble(),
                                            productRatingCount: productsList[index].rating!.count!.toInt(),
                                            productPrice: productsList[index].price!.toDouble(),
                                            productId: productsList[index].id!.toInt()),
                                      );
                                    })
                                : GridView.builder(
                                    itemCount: productsList.length,
                                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200, mainAxisExtent: 290),
                                    itemBuilder: (context, index) {
                                      print("length: " + productsList.length.toString());
                                      return ProductCard(
                                          productTitle: productsList[index].title.toString(),
                                          productImageURL: productsList[index].image.toString(),
                                          productRating: productsList[index].rating!.rate!.toDouble(),
                                          productRatingCount: productsList[index].rating!.count!.toInt(),
                                          productPrice: productsList[index].price!.toDouble(),
                                          productId: productsList[index].id!.toInt());
                                    }),
                          ),
                        ],
                      )));
  }
}

class CategoryButton extends StatefulWidget {
  final String categoryTitle;
  final void Function() onPressed;
  bool isSelected = false;

  CategoryButton({
    super.key,
    required this.categoryTitle,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  // final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: widget.isSelected
              ? const MaterialStatePropertyAll(Colors.white)
              : const MaterialStatePropertyAll(Color(0xff222222)),
          foregroundColor: widget.isSelected
              ? const MaterialStatePropertyAll(Color(0xff222222))
              : const MaterialStatePropertyAll(Colors.white),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child: Text(
          widget.categoryTitle,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
