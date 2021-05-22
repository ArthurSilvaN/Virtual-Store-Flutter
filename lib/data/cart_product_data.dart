import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtualflutter/data/product_data.dart';

class CartProduct{
  String cid;
  String catergory;
  String pid;
  int quantity;
  String size;
  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot documentSnapshot){
    cid = documentSnapshot.id;
    catergory = documentSnapshot.data()["Category"];
    pid = documentSnapshot.data()["pid"];
    quantity = documentSnapshot.data()["quantity"];
    size = documentSnapshot.data()["size"];
  }

  Map<String, dynamic> toMap(){
    return{
      "category": catergory,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      //"product": productData.toResumeMap()
    };
  }


}