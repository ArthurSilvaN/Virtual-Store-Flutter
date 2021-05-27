import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtualflutter/data/cart_product_data.dart';
import 'package:loja_virtualflutter/models/user_model.dart';
import 'package:loja_virtualflutter/services/result_cep.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:correios_frete/correios_frete.dart';

class CartModel extends Model{
  UserModel user;
  bool isLoading = false;
  String address;
  String endCep;

  List<CartProduct> products = [];

  String couponCode;
  int discountPercentage = 0;

  CartModel(this.user){
    if(user.isLoggedIn())
    _loadCartItems();
  }
  
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    if(findProductsCart(cartProduct) ==  false) {
      products.add(cartProduct);
      FirebaseFirestore.instance.collection("users").doc(user.firebaseUser.uid)
          .collection("cart").add(cartProduct.toMap()).then((doc) {
        cartProduct.cid = doc.id;
      });
      notifyListeners();
    }
  }

  Future<String> searchCep(String cepUser) async {
    final cep = cepUser;
    isLoading = true;

    final resultCep = await ViaCepService.fetchCep(cep: cep);

    this.endCep = resultCep.cep;

    String address = "${resultCep.logradouro}, ${resultCep.bairro} - ${resultCep
        .localidade} - ${resultCep.uf}";

    if(resultCep != null){
      Map<String, dynamic> userData = {
        "address": address
      };

      FirebaseFirestore.instance.collection("users")
          .doc(user.firebaseUser.uid)
          .update(userData);

      isLoading = false;
      return address;
    }else{
      Map<String, dynamic> userData = {
        "address": "null"
      };

      FirebaseFirestore.instance.collection("users")
          .doc(user.firebaseUser.uid)
          .update(userData);
    }
  }

  bool findProductsCart(CartProduct cartProduct){
     final index = products.indexWhere((element) => element.pid == cartProduct.pid && element.size == cartProduct.size);
     if(index >= 0){
       incProduct(products[index]);
       return true;
     } else {
       return false;
     }
  }

  void setCoupon(String coupon, int percentage){
    this.couponCode = coupon;
    this.discountPercentage = percentage;
  }

  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null)
        price += c.quantity * c.productData.price;
    }
    return price;
  }

  double getDiscount(){
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
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

  Future<String> finishOrder() async {
    if(products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await FirebaseFirestore.instance.collection("orders").add(
        {
          "clientId": user.firebaseUser.uid,
          "products": products.map((cartProduct)=>cartProduct.toMap()).toList(),
          "shipPrice": shipPrice,
          "productsPrice": productsPrice,
          "discount": discount,
          "totalPrice": productsPrice - discount + shipPrice,
          "status": 1
        }
    );

    await FirebaseFirestore.instance.collection("users").doc(user.firebaseUser.uid)
        .collection("orders").doc(refOrder.id).set(
        {
          "orderId": refOrder.id
        }
    );

    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(user.firebaseUser.uid)
        .collection("cart").get();

    for(DocumentSnapshot doc in query.docs){
      doc.reference.delete();
    }

    products.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.id;
  }

}