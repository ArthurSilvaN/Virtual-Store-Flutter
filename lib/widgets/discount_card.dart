import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtualflutter/models/cart_model.dart';

class DiscountCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text("Cupom de Desconto",
        textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey[700]
          ),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: [
          Padding(padding: EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Digite seu cupom"
            ),
            initialValue: CartModel.of(context).couponCode ?? "",
            onFieldSubmitted: (text){
              FirebaseFirestore.instance.collection("coupons").doc(text).get().then(
                  (doc){
                    if(doc.data() != null){
                      CartModel.of(context).setCupon(text, doc.data()["percent"]);
                      Scaffold.of(context).showSnackBar(
                        SnackBar(content:
                        Text("CUPOM DE ${doc.data()["precent"]}% APLICADO"),
                          backgroundColor: Colors.green,
                        )
                      );
                    }else {
                      CartModel.of(context).setCupon(null, 0);
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content:
                          Text("CUPOM INEXISTENTE"),
                            backgroundColor: Colors.red,
                          )
                      );
                    }
                  });
            },
          ),
          )
        ],
      ),
    );
  }
}
