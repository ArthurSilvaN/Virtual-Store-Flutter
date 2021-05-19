import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Widget _builderDrawerBack() =>
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 33, 156, 168),
                    Color.fromARGB(255, 170, 238, 222),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )
          ),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _builderDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
             children: <Widget>[
               Container(
                 margin: EdgeInsets.only(bottom: 8.0),
                 padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                 height: 170.0,
                 child: Stack(
                   children: <Widget>[
                     Positioned(
                       top: 8.0,
                       left: 0.0,
                       child: Text("Lolja",
                       style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold)
                       ),
                     )
                   ],
                 ),
               )
             ],
          )
        ],
      ),
    );
  }
}