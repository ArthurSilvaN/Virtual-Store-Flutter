import 'package:flutter/material.dart';
import 'package:loja_virtualflutter/Tabs/home_tab.dart';
import 'package:loja_virtualflutter/tabs/orders_tab.dart';
import 'package:loja_virtualflutter/tabs/partners_tab.dart';
import 'package:loja_virtualflutter/tabs/products_tab.dart';
import 'package:loja_virtualflutter/widgets/cart_button.dart';
import 'package:loja_virtualflutter/widgets/custom_drawer.dart';

class HomeScreen extends  StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          floatingActionButton: CartButton(),
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Parceiros"),
            centerTitle: true,
          ),
          body: PartnersTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageController),
        )
      ],
    );
  }
}
