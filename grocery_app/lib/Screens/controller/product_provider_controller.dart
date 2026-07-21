import 'package:flutter/material.dart';
import 'package:grocery_app/Screens/model/Product_model.dart';

class ProductProvider extends ChangeNotifier {
  final List<ProductModel> allProductdis =
      allProducts; // your full product list
  List<ProductModel> filterProducts = [];

  bool get isSearching => filterProducts.isNotEmpty;

  List<ProductModel> get products =>
      isSearching ? filterProducts : allProductdis;

  // Favorites
  final List<String> favProductset = [];
  bool isFavorite(String productId) => favProductset.contains(productId);

  void toggleFavoriteScreen(String productId) {
    if (favProductset.contains(productId)) {
      favProductset.remove(productId);
    } else {
      favProductset.add(productId);
    }
    notifyListeners();
  }

  List<ProductModel> get favProductScreenList =>
      allProductdis.where((p) => favProductset.contains(p.id)).toList();

  // Search
  void searchProduct(String query) {
    final que = query.trim().toLowerCase();
    if (que.isEmpty) {
      filterProducts = [];
    } else {
      filterProducts = allProductdis
          .where((p) => p.name.toLowerCase().contains(que))
          .toList();
    }
    notifyListeners();
  }

  // Cart
  List<String> cartProductListSet = [];

  void addToCart(String productId) {
    if (!cartProductListSet.contains(productId)) {
      cartProductListSet.add(productId);
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    if (cartProductListSet.contains(productId)) {
      cartProductListSet.remove(productId);
      cartQuantity.remove(productId);
      notifyListeners();
    }
  }

  // Cart Products
  List<ProductModel> get cartProductget =>
    allProductdis.where((p) => cartProductListSet.contains(p.id)).toList();

  // Quantity
  final Map<String, int> cartQuantity = {};

 void increaseQuantity(String productId) {
  if (cartQuantity.containsKey(productId)) {
    cartQuantity[productId] = cartQuantity[productId]! + 1;
  } else {
    cartQuantity[productId] = 1;
  }
  notifyListeners();
}

void decreaseQuantity(String productId) {
  if (cartQuantity.containsKey(productId) && cartQuantity[productId]! > 1) {
    cartQuantity[productId] = cartQuantity[productId]! - 1;
    notifyListeners();
  }
}




int getQuantity(String productId) => cartQuantity[productId] ?? 1;

void removeFromCartList(String productId) {
  if (cartProductListSet.contains(productId)) {
    cartProductListSet.remove(productId);
    cartQuantity.remove(productId);
    notifyListeners();
  }
}

}
