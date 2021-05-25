import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtualflutter/data/cart_product_data.dart';
import 'package:loja_virtualflutter/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{
  UserModel user;
  bool isLoading = false;

  List<CartProduct> products = [];

  CartModel(this.user){
    if(user.isLoggedIn())
    _loadCartItems();
  }
  
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);
    FirebaseFirestore.instance.collection("users").doc(user.firebaseUser.uid)
    .collection("cart").add(cartProduct.toMap()).then((doc){
      cartProduct.cid = doc.id;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){
    FirebaseFirestore.instance.collection("users").doc(user.firebaseUser.uid)
        .collection("cart").doc(cartProduct.cid).delete();

    products.remove(cartProduct);
    notifyListeners();
  }
  
  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;
    FirebaseFirestore.instance.collection("users").doc(user.firebaseUser.uid).collection("cart")
        .doc(cartProduct.cid).update(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;
    FirebaseFirestore.instance.collection("users").doc(user.firebaseUser.uid).collection("cart")
        .doc(cartProduct.cid).update(cartProduct.toMap());

    notifyListeners();
  }

  Future<void> _loadCartItems() async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(user.firebaseUser.uid).collection("cart")
        .get();

    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();
  }
}