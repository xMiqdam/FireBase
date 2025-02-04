import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController extends GetxController {
  var user = FirebaseAuth.instance.currentUser.obs;
  var profilePictureUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile(); // Memanggil metode untuk mendapatkan profil pengguna
  }

  // Mengambil gambar profil dari akun Google pengguna
  Future<void> fetchUserProfile() async {
    if (user.value != null) {
      try {
        // Mengambil gambar profil langsung dari akun Google (photoURL)
        String? profilePicUrl = user.value?.photoURL;
        profilePictureUrl.value = profilePicUrl ?? ''; // Jika kosong, tetap kosong

        // Jika Anda ingin mengambil data lainnya dari Firestore, Anda bisa menambahkannya di sini
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.value!.uid)
            .get();

        var data = userDoc.data() as Map<String, dynamic>?;
        // Jika ada data tambahan, misalnya nama, Anda bisa memperbarui di sini
      } catch (e) {
        print('Error fetching user profile: $e');
        profilePictureUrl.value = ''; // Menetapkan nilai kosong jika gagal
      }
    }
  }

  // Memperbarui pengguna jika diperlukan
  void updateUser(User? newUser) {
    user.value = newUser;
  }
}
