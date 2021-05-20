import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';


class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _builderBodyBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 211, 118, 130),
                Color.fromARGB(255, 253, 181, 168),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          )
      ),
    );

    return Stack(
      children: <Widget>[
        _builderBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Novidades"),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
              .collection("home").orderBy("pos").get(),
              // ignore: missing_return
              builder: (context, snapshot){
                if(!snapshot.hasData)
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,
                      alignment:  Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                else
                  print(snapshot.data.docs.length);
                return SliverStaggeredGrid.count(
                    crossAxisCount: 2,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  staggeredTiles: snapshot.data.docs.map(
                      (doc){
                        return StaggeredTile.count(doc.get('x'), doc.get('y'));
                      }
                  ).toList(),
                  children: snapshot.data.docs.map(
                          (doc){
                        return FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: doc.get("image"),
                          fit: BoxFit.cover,
                        );
                      }
                  ).toList(),
                );
              },
            )
          ],
        )
      ],
    );
  }
}
