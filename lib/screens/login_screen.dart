import 'package:flutter/material.dart';
import 'package:loja_virtualflutter/models/user_model.dart';
import 'package:loja_virtualflutter/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: [
            FlatButton(
              child: Text(
                "CRIAR CONTA",
                style: TextStyle(fontSize: 15.0),
              ),
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignupScreen()));
              },
            )
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    // ignore: missing_return
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@"))
                        return "E-mail inválido!";
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Visibility(
                    visible: _visible,
                    child: TextFormField(
                      controller: _passController,
                      decoration: InputDecoration(hintText: "Senha"),
                      obscureText: true,
                      // ignore: missing_return
                      validator: (text) {
                        if (text.isEmpty || text.length < 6)
                          return "Senha Inválida";
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _visible = !_visible;
                          // ignore: deprecated_member_use
                          if (!_visible) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Insira o email para recuperação"),
                              backgroundColor: Theme
                                  .of(context)
                                  .primaryColor,
                              duration: Duration(seconds: 2),
                            ));
                          }
                        });
                      },
                      child: Text(
                        "Esqueci minha senha",
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Visibility(
                      child: Visibility(
                        visible: _visible,
                        child: SizedBox(
                          height: 44.0,
                          child: RaisedButton(
                            child: Text(
                              "Entrar",
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            textColor: Colors.white,
                            color: Theme
                                .of(context)
                                .primaryColor,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                model.signIn(
                                    email: _emailController.text,
                                    pass: _passController.text,
                                    onSucces: _onSuccess,
                                    onFailure: _onFailure);
                              }
                            },
                          ),
                        ),
                      )),
                  AnimatedOpacity(
                    opacity: !_visible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text(
                          "Recuperar Senha",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        textColor: Colors.white,
                        color: Colors.greenAccent,
                        onPressed: () {
                          setState(() {
                            if (_emailController.text.isEmpty ||
                                !_emailController.text.contains("@"))
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Email inexistente!"),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 2),
                              ));
                            else {
                              _visible = !_visible;
                              model.recoverPass(_emailController.text);
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Confira seu email!"),
                                backgroundColor: Theme
                                    .of(context)
                                    .primaryColor,
                                duration: Duration(seconds: 2),
                              ));
                            }
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        )
    );
  }
    void _onSuccess() {
      Navigator.of(context).pop();
    }

    void _onFailure() {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Falha ao entrar!"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }

}
