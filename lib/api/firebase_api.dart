import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynoteapps/main.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _auth = FirebaseAuth.instance;
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

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
      arguments: message,
    );
  }

  Future<void> initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  Future<DocumentReference> addNote(String note) async {
    User? user = _auth.currentUser;

    if (user == null) {
      print("User not logged in");
      throw Exception("User not logged in");
    }

    String? photoUrl = user.photoURL ?? ''; 

    return await notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
      'userId': user.uid,
      'userName': user.displayName ?? 'Unknown User',
      'userPhoto': photoUrl,
    });
  }

  Stream<QuerySnapshot> getNotesStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> updateNote(String docID, String newNote) async {
    return await notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteNote(String docID) async {
    return await notes.doc(docID).delete();
  }
}
