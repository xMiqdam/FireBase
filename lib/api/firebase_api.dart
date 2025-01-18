import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mynoteapps/main.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token :$fCMToken');
    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      'notification_screen',
      arguments: message, // Pastikan `message` diteruskan
    );
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  Future <void> addNote(String note){
    return notes.add({ 
      'note': note,
      'timestamp' : Timestamp.now(),
    });
  }
  Stream<QuerySnapshot>getNotesStream(){
   final notesStream = notes.orderBy('timestamp',descending: true).snapshots();

   return notesStream;
  }
  
    Future<void> updateNote(String docID, String newNote){
    return notes.doc(docID).update({
      'note' : newNote,
      'timestamp' : Timestamp.now(),
    });
  }

  Future<void> deleteNote(String docID){
    return notes.doc(docID).delete();
  }

}
