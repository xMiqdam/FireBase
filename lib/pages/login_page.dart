import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mynoteapps/widget/MyColors.dart';
import 'package:mynoteapps/widget/MyText.dart';
import 'package:mynoteapps/widget/MyTextField.dart';
import 'home_page.dart';

class SignInScreen extends StatelessWidget {
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

      return userCredential.user;
    } catch (e) {
      print('Error during Google Sign-In: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: lightBeige,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyText(
                  text: 'Notemad',
                  style: TextStyle(
                    fontFamily: 'Cursive',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: blackz,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        MyText(
                          text: 'Login',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: blackz,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        MyTextField(
                          hintText: 'Email',
                          isPassword: false,
                          controller: emailController,
                          icon: Icons.email,
                          textFieldColor: lightBeige,
                          textColor: blackz,
                        ),
                        MyTextField(
                          hintText: 'Password',
                          isPassword: true,
                          controller: passwordController,
                          icon: Icons.lock,
                          textFieldColor: lightBeige,
                          textColor: blackz,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tealGreen,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: MyText(
                            text: 'Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: MyText(
                                text: 'Or',
                                style: TextStyle(
                                  color: blackz,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey)),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () async {
                            User? user = await signInWithGoogle(context);
                            if (user != null) {
                              print('User in: ${user.displayName}');
                            }
                          },
                          icon: Icon(Icons.g_mobiledata, color: Colors.white),
                          label: MyText(
                            text: 'Login with Google',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tealGreen,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
