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
                String cep = snapshot.data["address"];
                if (cep == "null, null - null - null") {
                  return Column(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                      ),
                      Text(
                        "\nCPF INVÁLIDO",
                        style: TextStyle(color: Colors.red),
                      ),
                      Divider()
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Icon(Icons.location_on),
                      Text("\n${cep}"),
                      Divider()
                    ],
                  );
                }
              }
            }));
  }
}
