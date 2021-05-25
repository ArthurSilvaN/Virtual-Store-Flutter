import 'package:flutter/material.dart';
import 'package:loja_virtualflutter/models/user_model.dart';
import 'package:loja_virtualflutter/screens/login_screen.dart';
import 'package:loja_virtualflutter/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;
  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _builderDrawerBack() =>
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 156, 201, 205),
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
                 height: 230.0,
                 child: Stack(
                   children: <Widget>[
                     Align(
                       child: Image.network("https://d119kxa4ljimqi.cloudfront.net/images/l/Lolja_9.png",
                       height: 150.0,
                       alignment: Alignment.topCenter,),
                     ),
                     Positioned(
                       left: 0.0,
                       bottom: 0.0,
                       child: ScopedModelDescendant<UserModel>(
                         builder: (context, child, model){
                           return Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: <Widget>[
                               Text("Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}",
                                 style: TextStyle(
                                     fontSize: 18.0,
                                     fontWeight: FontWeight.bold
                                 ),
                               ),
                               GestureDetector(
                                 child: Text(
                                   !model.isLoggedIn() ? "Entre ou Cadastre-se" : "Sair",
                                   style: TextStyle(
                                       color: Theme.of(context).primaryColor,
                                       fontSize: 16.0,
                                       fontWeight: FontWeight.bold
                                   ),
                                 ),
                                 onTap: (){
                                   if(!model.isLoggedIn())
                                   Navigator.of(context).push(
                                       MaterialPageRoute(builder: (context) => LoginScreen())
                                   );
                                   else
                                     model.signOut();
                                 },
                               )
                             ],
                           );
                         },
                       ),
                     )
                   ],
                 ),
               ),
               Divider(),
               DrawerTile(Icons.home, "Inicio", pageController,0),
               DrawerTile(Icons.list, "Produtos", pageController, 1),
               DrawerTile(Icons.wb_incandescent, "Parceiros", pageController, 2),
               DrawerTile(Icons.playlist_add_check, "Meus Pedidos", pageController, 3),
             ],
          )
        ],
      ),
    );
  }
}
