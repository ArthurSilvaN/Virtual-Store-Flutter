import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtualflutter/data/product_data.dart';
import 'package:loja_virtualflutter/tiles/product_tile.dart';
import 'package:loja_virtualflutter/widgets/cart_button.dart';

class CategoryScreen extends StatelessWidget {
  final QueryDocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: CartButton(),
          appBar: AppBar(
            title: Text(snapshot.data()["title"]),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.list),
                )
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection("products")
                .doc(snapshot.id)
                .collection("intems")
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else
                return TabBarView(
                  children: [
                    GridView.builder(
                      padding: EdgeInsets.all(4.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index){
                        ProductData data = ProductData.fromDocument(snapshot.data.docs[index]);
                        data.category = this.snapshot.id;
                        return ProductTile("grid", data);
                      },
                    ),
                    ListView.builder(
                      padding: EdgeInsets.all(3.0),
                      itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index){
                          return ProductTile("list", ProductData.fromDocument(snapshot.data.docs[index]));
                        }
                    )
                  ],
                );
            },
          )
      ),
    );
  }
}
