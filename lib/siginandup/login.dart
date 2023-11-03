import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../component/Textformfield.dart';
import '../component/customButton.dart';
import '../component/customLogoauth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  bool isloading = false;




  Future<void> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the sign-in, you might want to handle this case
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

        Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);

    } catch (e) {
      // Handle any errors that occurred during the sign-in process
      print("Error signing in with Google: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:isloading?const Center(child: CircularProgressIndicator(),) : Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: formstate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                  ),
                  const CustomLogoAuth(),
                  Container(
                    height: 15,
                  ),
                  const Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Login to continue using the App",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Container(
                    height: 20,
                  ),
                  const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Container(
                    height: 10,
                  ),
                  AuthTextFormField(
                      hinttext: 'Enter your email address',
                      mycontroller: email,
                      validator: (val) {
                        if (val == "") {
                          return "Can't be Empty";
                        }
                      }),
                  Container(
                    height: 15,
                  ),
                  const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Container(
                    height: 10,
                  ),
                  AuthTextFormField(
                    hinttext: 'Enter your password',
                    mycontroller: password,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be Empty";
                      }
                    },
                  ),
                  InkWell(
                    onTap: () async{

                      if(email.text==""){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'الرجاء كتابه البريد الالكتروني الخاص بك ثم اضغط علي forget password  ',
                        ).show();
                        return ;
                      }
                      try{
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'Success',
                          desc: 'الرجاء التوجه الي بريدك الالكتروني و الضغط علي لينك التحقق حتي يسمح لك بتغيير كلمه المرور ',
                        ).show();

                      }catch(e){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'الرجاء التاكد من ان البريد الالكتروني الذي ادخلته صحيح ثم قم باعاده المحاوله ',
                        ).show();
                      }
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      child: const Text(
                        "Forget password ?",
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
            ),
            CustomButtonAuth(
              text: "Login",
              onPressed: () async {
                if (formstate.currentState!.validate()) {
                  try {
                    isloading=true;
                    setState(() {

                    });
                    final credential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    isloading=false;
                    setState(() {

                    });

                    if(credential.user!.emailVerified){
                      Navigator.of(context).pushNamedAndRemoveUntil("homepage",(route)=> false);
                    }else{
                      FirebaseAuth.instance.currentUser!.sendEmailVerification();
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'الرجاء التوجه الي بريدك الالكتروني و الضغط علي لينك التحقق حتي يتم تسجيل الدخول ',
                      ).show();
                    }

                  } on FirebaseAuthException catch (e) {
                    isloading=false;
                    setState(() {

                    });
                    if (e.code == 'user-not-found') {
                      print('-------------------------------------No user found for that email.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'The password provided is too weak.',
                      ).show();
                    } else if (e.code == 'email-already-in-use') {
                      print('No found user please create a new Account');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'No found user please create a new Account.',
                      ).show();
                    }
                  }
                } else {
                  print("not valid");
                }
              }, color: Colors.blue,
            ),
            Container(
              height: 20,
            ),
            MaterialButton(
              color: Colors.red,
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () {
                 signInWithGoogle();
              },
              textColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Login with Google",
                    style: TextStyle(fontSize: 11),
                  ),
                  Image.asset(
                    "assets/image/google.png",
                    width: 20,
                  ),
                ],
              ),
            ),
            Container(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("signup");
              },
              child: const Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: "Don't Have An Account ?",
                      style: TextStyle(fontSize: 11)),
                  TextSpan(
                      text: "Register",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.orange)),
                ])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
