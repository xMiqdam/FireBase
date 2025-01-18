import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynoteapps/api/firebase_api.dart';
import 'package:mynoteapps/widget/MyColors.dart';
import 'package:mynoteapps/widget/MyText.dart';
import 'package:mynoteapps/widget/MyTextField.dart';
import 'package:mynoteapps/widget/MyButton.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseApi firebaseapi = FirebaseApi();
  final TextEditingController textController = TextEditingController();

  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: lightBeige,
        content: MyTextField(
          controller: textController,
          hintText: "Enter your note here",
          isPassword: false,
          icon: Icons.note,
          textFieldColor: Colors.white,
          textColor: blackz,
        ),
        actions: [
          MyButton(
            textButton: "Add",
            backgroundColor: tealGreen,
            textColor: Colors.white,
            onPressed: () {
              if (docID == null) {
                firebaseapi.addNote(textController.text);
              } else {
                firebaseapi.updateNote(docID, textController.text);
              }
              textController.clear();
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(10),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: MyText(
                text: 'Hi User',
                style: TextStyle(
                  fontFamily: 'Cursive',
                  fontSize: 20,
                  color: blackz,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
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
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String noteText = data['note'];
                  return Card(
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
                          Spacer(),
                          Divider(color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => firebaseapi.deleteNote(docID),
                                icon: Icon(Icons.delete),
                              ),
                              IconButton(
                                  onPressed: () => openNoteBox(docID: docID),
                                  icon: Icon(Icons.edit)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: MyText(
                  text: "No notes available.",
                  style: TextStyle(
                    fontSize: 16,
                    color: blackz,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
