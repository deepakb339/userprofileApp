import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:userProfile/home.dart';

import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  bool showProgress = false;
  String fname, lname, age, phone, email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
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
                      "Create Profile Page",
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        fname = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Value Can\'t Be Empty";
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your First Name:",
                          labelText: "First Name",
                          prefixIcon: Icon(FontAwesomeIcons.user),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)))),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        lname = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Value Can\'t Be Empty";
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your Last Name:",
                          labelText: "Last Name",
                          prefixIcon: Icon(FontAwesomeIcons.userAlt),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)))),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        age = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Value Can\'t Be Empty";
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your Age:",
                          labelText: "Age",
                          prefixIcon: Icon(FontAwesomeIcons.sortNumericDown),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)))),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      onSaved: (value) {
                        phone = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Value Can\'t Be Empty";
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Enter your Phone no:",
                          labelText: "Phone no.",
                          prefixIcon: Icon(FontAwesomeIcons.phone),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0)))),
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
                          prefixIcon: Icon(Icons.mail),
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
                          prefixIcon: Icon(FontAwesomeIcons.lock),
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
                              final newuser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                              await _auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                              final FirebaseUser currentUser =
                                  await _auth.currentUser();
                              _firestore
                                  .collection('users')
                                  .document(currentUser.uid.toString())
                                  .setData({
                                'fname': fname,
                                'lname': lname,
                                'age': age,
                                'phone': phone,
                                'email': email,
                              });

                              if (newuser != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );

                                setState(() {
                                  showProgress = false;
                                });
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        minWidth: 200.0,
                        height: 45.0,
                        child: Text(
                          "Create Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyLoginPage()),
                        );
                      },
                      child: Text(
                        "Already have profile? Login Now",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w900),
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
