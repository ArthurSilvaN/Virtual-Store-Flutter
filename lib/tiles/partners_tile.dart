import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class PartnersTile extends StatelessWidget {

  final DocumentSnapshot snapshot;

  PartnersTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("partners")
                .doc()
                .snapshots(),
            builder: (context, snapshot) {
              {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Card(
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: this.snapshot.data()["image"],
                    ),
                    margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                  );
                }
              }
            })
    );
  }
}
