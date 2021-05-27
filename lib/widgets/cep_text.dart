import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtualflutter/models/user_model.dart';

class CepText extends StatelessWidget {
  UserModel userModel;

  CepText(this.userModel);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(userModel.firebaseUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              {
                return Column(
                  children: [
                    Icon(Icons.location_on),
                    Text("\n${snapshot.data["address"]}"),
                    Divider()
                  ],
                );
              }
            }));
  }
}
