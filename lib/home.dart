import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  String fname, lname, age, phone, email;
  bool showProgress = false;

  _getData() async {
    final FirebaseUser currentUser = await _auth.currentUser();
    DocumentReference documentReference =
        _firestore.collection('users').document(currentUser.uid.toString());
    documentReference.get().then((datasnapshot) {
      setState(() {
        fname = datasnapshot.data['fname'];
        lname = datasnapshot.data['lname'];
        age = datasnapshot.data['age'];
        phone = datasnapshot.data['phone'];
        email = datasnapshot.data['email'];
      });
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        centerTitle: true,
      ),
      body: (fname == null)
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.blue,
                        child: CircleAvatar(
                          radius: 50,
                          child: Text(
                            fname.characters.first + lname.characters.first,
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Hi, $fname $lname",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "First name: $fname",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Last name: $lname",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Age: $age",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Phone no.: $phone",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Email: $email",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Material(
                        elevation: 5,
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(32.0),
                        child: MaterialButton(
                          onPressed: () {
                            _showDialog();
                          },
                          minWidth: 200.0,
                          height: 45.0,
                          child: Text(
                            "Edit",
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
    );
  }

  _showDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User Profile'),
          content: SingleChildScrollView(
            child: ModalProgressHUD(
              inAsyncCall: showProgress,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.text,
                        initialValue: fname,
                        onSaved: (value) {
                          setState(() {
                            fname = value;
                          });
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
                        initialValue: lname,
                        onSaved: (value) {
                          setState(() {
                            lname = value;
                          });
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
                        initialValue: age,
                        onSaved: (value) {
                          setState(() {
                            age = value;
                          });
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
                        initialValue: phone,
                        maxLength: 10,
                        onSaved: (value) {
                          setState(() {
                            phone = value;
                          });
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
                        initialValue: email,
                        onSaved: (value) {
                          setState(() {
                            email = value;
                          });
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Save'),
              onPressed: () async {
                Navigator.of(context).pop();
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setState(() {
                    showProgress = true;
                  });
                  try {
                    final FirebaseUser currentUser = await _auth.currentUser();
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
                    setState(() {
                      showProgress = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                }
                Fluttertoast.showToast(
                    msg: "Successfuly Saved",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
            ),
          ],
        );
      },
    );
  }
}
