import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/View/AllScreens/register-screen.dart';
import 'package:rider_app/View/widgets/progressDialog.dart';

import '../../main.dart';
import 'mainscreen.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "Login";

   LoginScreen({Key key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                  "Login As Rider",
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
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
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
                        controller: passwordController,
                        obscureText: true,
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
                        height: 22.0,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(

                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                           if(!emailController.text.contains("@")){
                             displayToastMSG("invalid email");
                           }else if(passwordController.text.length < 4){
                             displayToastMSG("password must be more than 4 ch");

                           }else{
                             loginAndAuthUser(context);
                           }
                          },
                          child: Center(
                            child: Text("LogIn"),
                          ))
                    ],
                  ),
                ),
                TextButton(onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, RegisterScreen.idScreen, (route) => false);
                }, child: Text("Do Not Have an Account? Register Here"))
              ],
            ),
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthUser(BuildContext context)async {
    showDialog(context: context,
        barrierDismissible: false,

        builder: (BuildContext context){
      return ProgressDialog(message: "Authentication , Please Wait...",);
    });
    var firebaseAuth =
    await _firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
    ).catchError((err){
      Navigator.pop(context);
      displayToastMSG("error: "+err.toString());

    });
    if(firebaseAuth !=null){
      userRef.child(firebaseAuth.user.uid).once().then((DataSnapshot snap){
        if(snap.value !=null){
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMSG("you ar login now");
        }else{
          Navigator.pop(context);

          _firebaseAuth.signOut();
          displayToastMSG("no record exists , please create new account");

        }
      });
    }else{
      Navigator.pop(context);

      displayToastMSG("Error occured can not");
    }
  }

  void displayToastMSG(String msg) {
    Fluttertoast.showToast(msg: msg);
  }
}
