import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mynoteapps/api/firebase_api.dart';
import 'login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseApi firebaseapi = FirebaseApi();

  final TextEditingController textController = TextEditingController();

  Future<void> signOut(BuildContext context) async {
    try {
    
      await FirebaseAuth.instance.signOut();
      
    
      await GoogleSignIn().signOut();
      
    
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } catch (e) {
      print('Error during sign-out: $e');
    }
  }

  void openNoteBox(){
    showDialog(context: context, builder: (context) => AlertDialog(
      content: TextField(
        controller: textController,
      ),
      actions: [
        ElevatedButton(onPressed: () {
          firebaseapi.addNote(textController.text);

          textController.clear();

          Navigator.pop(context);
        }, child: Text("Add"))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              signOut(context);  
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firebaseapi.getNotesStream(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              List notesList = snapshot.data!.docs;
              return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docID = document.id;
                Map<String, dynamic> data = document.data() as Map<String,dynamic>;
                String noteText = data['note'];
                return ListTile(
                  title: Text(noteText),
                );
              },);
            }else{
              return const Text( "no notes");
            }
          },
        ),
    );
  }
}