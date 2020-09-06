import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home.dart';

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile Login"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ModalProgressHUD(
            inAsyncCall: showProgress,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Login Page",
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        email = value;
                      },
                      validator: (value) {
                        if (!EmailValidator.validate(value)) {
                          return 'Please enter a valid email';
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your Email:",
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)))),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      onSaved: (value) {
                        password = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Value Can\'t Be Empty";
                        } else if (value.length < 6) {
                          return "Password length must be greater than 6";
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your Password",
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)))),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Material(
                      elevation: 5,
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(32.0),
                      child: MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            setState(() {
                              showProgress = true;
                            });

                            try {
                              _auth.signOut();
                              final newUser =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);

                              print(newUser.toString());

                              if (newUser != null) {
                                Fluttertoast.showToast(
                                    msg: "Login Successfull",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.blueAccent,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                                setState(() {
                                  showProgress = false;
                                });
                              }
                            } catch (e) {}
                          }
                        },
                        minWidth: 200.0,
                        height: 45.0,
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
