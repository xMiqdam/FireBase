import 'package:get/get.dart';
import '../controller/logincontroller.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies(){
    Get.put(LoginController);
  }
}