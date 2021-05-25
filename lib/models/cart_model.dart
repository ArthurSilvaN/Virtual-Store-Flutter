import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtualflutter/data/cart_product_data.dart';
import 'package:loja_virtualflutter/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{
  UserModel user;
  bool isLoading = false;

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
    if(findProductsCart(cartProduct.cid) == true){
      incProduct(cartProduct);
    } else {
      products.add(cartProduct);
      FirebaseFirestore.instance.collection("users").doc(user.firebaseUser.uid)
          .collection("cart").add(cartProduct.toMap()).then((doc) {
        cartProduct.cid = doc.id;
      });
    }

    notifyListeners();
  }

  bool findProductsCart(String id){
    products.firstWhere((element) {
      if(element.cid == id){
        return true;
      } else return false;
    });
  }

  void setCupon(String coupon, int percentage){
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

  double getShipPrice(){
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