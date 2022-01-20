import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/View/widgets/progressDialog.dart';
import 'package:rider_app/main.dart';

import 'login-screen.dart';
import 'mainscreen.dart';

class RegisterScreen extends StatelessWidget {
  static const String idScreen = "Register";

  RegisterScreen({Key key}) : super(key: key);

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 66.0,
                ),
                Image(
                  image: AssetImage("assets/images/transport.png"),
                  height: 120.0,
                  width: 120.0,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Register As Rider",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 2.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: "Phone",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 22.0,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            if (nameController.text.length < 4) {
                              displayToastMSG("name must by at least 4 ch");
                            } else if(!emailController.text.contains("@")){
                              displayToastMSG("email is not valid");

                            } else if(phoneController.text.length < 8){
                              displayToastMSG("phone number must be at least 8 ");

                            } else if(emailController.text.length <4){
                              displayToastMSG("password must by more than 3 ch");

                            }
                            else{
                              registerNewUser(context);

                            }
                          },
                          child: Center(
                            child: Text("Create Account"),
                          ))
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.idScreen, (route) => false);
                    },
                    child: Text("Already have an account? Login Here"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(context: context,
        barrierDismissible: false,

        builder: (BuildContext context){
          return ProgressDialog(message: "Registering , Please Wait...",);
        });
     var firebaseAuth =
        await _firebaseAuth.createUserWithEmailAndPassword(
                email: emailController.text,
            password: passwordController.text
        ).catchError((err){
          Navigator.pop(context);
          displayToastMSG("error:  "+err.toString());

        });

    if(firebaseAuth !=null){

      Map userDataMap = {
        "name":nameController.text.trim(),
        "email":emailController.text.trim(),
        "phone":phoneController.text.trim(),

      };

      userRef.child(firebaseAuth.user.uid).set(userDataMap);
      displayToastMSG("your account has been created");
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

    }else{
      Navigator.pop(context);
      displayToastMSG("new user has not been created");
    }
  }

  void displayToastMSG(String msg) {
    Fluttertoast.showToast(msg: msg);
  }
}
