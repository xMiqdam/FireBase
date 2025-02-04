import 'package:get/get.dart';
import '../controller/logincontroller.dart';
import '../controller/usercontroller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<UserController>(() => UserController()); // Tambahkan UserController
  }
}
