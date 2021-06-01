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
        child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection("partners")
                .orderBy("pos")
                .get(),
            builder: (context, snapshot) {
              {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Card(
                    child: Container(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: this.snapshot.data()["image"],
                          ),
                            Text(
                              this.snapshot.data()["title"],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0,
                                fontSize: 25,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }
              }
            }));
  }
}
