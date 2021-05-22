import 'package:flutter/material.dart';
import 'package:loja_virtualflutter/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addresController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if(model.isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: "Nome Completo"
                  ),
                  // ignore: missing_return
                  validator: (text){
                    if(text.isEmpty) return "Nome inválido!";
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: "Email"
                  ),
                  keyboardType: TextInputType.emailAddress,
                  // ignore: missing_return
                  validator: (text){
                    if(text.isEmpty || !text.contains("@")) return "E-mail inválido!";
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                      hintText: "Senha"
                  ),
                  obscureText: true,
                  // ignore: missing_return
                  validator: (text){
                    if(text.isEmpty || text.length < 6) return "Senha Inválida";
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _addresController,
                  decoration: InputDecoration(
                      hintText: "Endereço"
                  ),
                  keyboardType: TextInputType.streetAddress,
                  // ignore: missing_return
                  validator: (text){
                    if(text.isEmpty) return "Endereço inválido!";
                  },
                ),
                SizedBox(height: 16.0,),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    child: Text(
                      "Criar Conta",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      if(_formKey.currentState.validate()){

                        Map<String, dynamic> userData = {
                          "name": _nameController.text,
                          "email": _emailController.text,
                          "address": _addresController.text
                        };

                        model.signUp(
                            userData: userData,
                            pass: _passController.text,
                            onSuccess: _onSuccess,
                            onFail: _onFailure);
                      }
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
}
  void _onSuccess() {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Usuario criado com sucesso!"),
          backgroundColor: Colors.greenAccent,
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFailure() {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao criar usuário!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        )
    );
  }
}
