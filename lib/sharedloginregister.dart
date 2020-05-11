// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String email, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {

    var url = 'https://your_url/name.php';
    Response response = await http.post(url, body: {
      "user": email,
      "pass": password,
      "role": "Admin",
    });

    String value = response.body;
    String user_ = email;
    String pass_ = password;
    String role_ = "Admin";

    if (value == "True") {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, user_, pass_, role_);
      });
      loginToast("Login Successfully");
    } else {
      loginToast("Login Failed");
    }
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black38,
        textColor: Colors.white);
  }

  savePref(String value, String user_, String pass_, String role_) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("value", value);
      preferences.setString("user", user_);
      preferences.setString("pass", pass_);
      preferences.setString("role", role_);
      preferences.commit();
    });
  }

  var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getString("value");

      _loginStatus = value == "True" ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("user", null);
      preferences.setString("pass", null);
      preferences.setString("role", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              children: <Widget>[
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "images/logo.png",
                            height: 250,
                            width: 250,
                            colorBlendMode: BlendMode.darken,
                            fit: BoxFit.fitWidth,
                          ),

                          SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Card(
                            elevation: 6.0,
                            child: TextFormField(
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please Insert Username";
                                }
                              },
                              onSaved: (e) => email = e,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding:
                                    EdgeInsets.only(left: 20, right: 15),
                                    child:
                                    Icon(Icons.person, color: Colors.black),
                                  ),
                                  contentPadding: EdgeInsets.all(18),
                                  labelText: "Username"),
                            ),
                          ),
                          Card(
                            elevation: 6.0,
                            child: TextFormField(
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Password Can't be Empty";
                                }
                              },
                              obscureText: _secureText,
                              onSaved: (e) => password = e,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.phonelink_lock,
                                      color: Colors.black),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: showHide,
                                  icon: Icon(_secureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                contentPadding: EdgeInsets.all(18),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          FlatButton(
                            onPressed: ()
                            {
                              showDialog(context: context, child: AlertDialog(
                                title: new Text("Please Call at 8951992208"),
                              ));
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(14.0),
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(
                                height: 50.0,
                                width: 150.00,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15.0)),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    textColor: Colors.white,
                                    color: Colors.indigo,
                                    onPressed: () {
                                      check();
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        break;

      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
    }
  }
}

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;

  MainMenu(this.signOut);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  int currentIndex = 0;
  String selectedIndex = 'TAB: 0';

  String user = "", pass = "", role = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      role = preferences.getString("role");
      user = preferences.getString("user");
      pass = preferences.getString("pass");
    });
    print("role" + role);
    print("user" + user);
    print("pass" + pass);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logo Demo'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              signOut();
            },
            tooltip: 'LogOut',
            iconSize: 30,
            color: Colors.white,
            icon: Icon(Icons.lock_open),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Image.asset(
          "images/logo.png",
          height: 150,
          width: 250,
          colorBlendMode: BlendMode.darken,
          fit: BoxFit.fitWidth,
          ),
            SizedBox(
                height: 15.0),
            ButtonTheme(
              minWidth: 200.0,
              height: 50.0,
              child: RaisedButton(
                padding: const EdgeInsets.all(8.0),
                textColor: Colors.white,
                color: Colors.indigo,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                child: Text('Button', style: TextStyle(fontSize: 20),),
//                onPressed: () {
//                  );
//                },
              ),
            ),
            SizedBox(
                height: 15.0),
          ]
    ),
    ),
    );
  }

  callToast(String msg) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
