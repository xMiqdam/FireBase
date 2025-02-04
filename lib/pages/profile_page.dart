import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mynoteapps/controller/usercontroller.dart';
import 'package:mynoteapps/pages/login_page.dart';
import 'package:mynoteapps/widget/MyColors.dart';
import 'package:mynoteapps/widget/MyText.dart';

class ProfilePage extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error during sign-out: $e');
    }
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: lightBeige,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: MyText(
            text: "Konfirmasi Log Out",
            style: TextStyle(fontSize: 20, color: blackz),
            textAlign: TextAlign.left,
          ),
          content: MyText(
            text: "Apakah Anda yakin ingin log out?",
            style: TextStyle(fontSize: 16, color: blackz),
            textAlign: TextAlign.left,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog tanpa log out
              },
              child: MyText(
                text: "Batal",
                style: TextStyle(fontSize: 16, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                signOut(context); // Panggil fungsi log out
              },
              style: TextButton.styleFrom(
                backgroundColor: tealGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: MyText(
                text: "Log Out",
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Mengambil data pengguna dari FirebaseAuth

    return Scaffold(
      backgroundColor: lightBeige,
      appBar: AppBar(
        title: MyText(
          text: 'Profile',
          style: TextStyle(color: blackz),
          textAlign: TextAlign.center,
        ),
        backgroundColor: lightBeige,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null 
                  ? NetworkImage(user!.photoURL!) 
                  : AssetImage('assets/default_profile_picture.png') as ImageProvider,
            ),
            SizedBox(height: 20),
            MyText(
              text: user?.displayName ?? 'User Name', // Menampilkan nama pengguna dari akun Google
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () { 
                showLogoutConfirmationDialog(context); // Tampilkan dialog konfirmasi log out
              },
              child: MyText(
                text: 'Log Out',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor, // Gunakan warna merah untuk tombol log out
              ),
            ),
          ],
        ),
      ),
    );
  }
}
