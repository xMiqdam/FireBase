import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:mynoteapps/api/firebase_api.dart';
import 'package:mynoteapps/pages/login_page.dart';
import 'package:mynoteapps/widget/MyColors.dart';
import 'package:mynoteapps/widget/MyText.dart';
import 'package:mynoteapps/widget/MyTextField.dart';
import 'package:mynoteapps/widget/MyButton.dart';

class HomePage extends StatelessWidget {
  final FirebaseApi firebaseapi = FirebaseApi();
  final TextEditingController textController = TextEditingController();

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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: blackz,
            ),
            textAlign: TextAlign.left,
          ),
          content: MyText(
            text: "Apakah Anda yakin ingin log out?",
            style: TextStyle(
              fontSize: 16,
              color: blackz,
            ),
            textAlign: TextAlign.left,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog tanpa log out
              },
              child: MyText(
                text: "Batal",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: MyText(
                text: "Log Out  ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  void openNotePreview({required BuildContext context, required String docID, required String currentNote}) {
    textController.text = currentNote; // Set teks catatan ke controller

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: lightBeige,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: "Preview Note",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: blackz,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 12),
            TextField(
              controller: textController,
              maxLines: 6,
              readOnly: true, // Membuat field hanya untuk membaca
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "No content available",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Tambahkan dialog konfirmasi sebelum menghapus
              Get.defaultDialog(
                title: "Konfirmasi Hapus",
                titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                middleText: "Apakah Anda yakin ingin menghapus catatan ini?",
                middleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
                backgroundColor: lightBeige,
                barrierDismissible: false,
                textCancel: "Cancel",
                cancelTextColor: Colors.red,
                textConfirm: "Ya",
                confirmTextColor: Colors.white,
                buttonColor: tealGreen,
                onConfirm: () {
                  firebaseapi.deleteNote(docID); // Hapus catatan dari Firestore
                  textController.clear();
                  Get.back(); // Tutup dialog konfirmasi
                  Navigator.pop(context); // Tutup preview note
                },
                onCancel: () {
                  Get.back(); // Tutup dialog konfirmasi tanpa menghapus
                },
              );
            },
            icon: Icon(Icons.delete, color: Colors.red),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openNoteEditor(context: context, docID: docID, currentNote: currentNote);
            },
            style: TextButton.styleFrom(
              backgroundColor: tealGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: MyText(
              text: "Edit",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void openNoteEditor({required BuildContext context, String? docID, String? currentNote}) {
    textController.text = currentNote ?? ''; // If there is an existing note, set it. Otherwise, leave it empty.

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: lightBeige,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: docID == null ? "Add Note" : "Edit Note", // Show 'Add Note' for creating a new note
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: blackz,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 12),
            TextField(
              controller: textController,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Enter your note here",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              textController.clear(); // Clear the text field when closing
              Navigator.pop(context);
            },
            child: MyText(
              text: "Close",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: () {
              if (docID == null) {
                // Create a new note
                firebaseapi.addNote(textController.text);
              } else {
                // Update an existing note
                firebaseapi.updateNote(docID, textController.text);
              }
              textController.clear(); // Clear text after saving
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: tealGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: MyText(
              text: docID == null ? "Create" : "Update", // Use 'Create' for new notes, 'Update' for editing
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBeige,
      appBar: AppBar(
        backgroundColor: lightBeige,
        elevation: 0,
        title: MyText(
          text: 'Notemad',
          style: TextStyle(
            fontFamily: 'Cursive',
            fontSize: 28,
            color: blackz,
          ),
          textAlign: TextAlign.left,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              showLogoutConfirmationDialog(context); // Tampilkan dialog konfirmasi
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteEditor(context: context),
        backgroundColor: tealGreen,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: firebaseapi.getNotesStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot> notesList = snapshot.data!.docs;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = notesList[index];
                  String docID = document.id;
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  String noteText = data['note'];

                  return GestureDetector(
                    onTap: () => openNotePreview(context: context, docID: docID, currentNote: noteText),
                    child: Card(
                      elevation: 4,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text: noteText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: blackz,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
