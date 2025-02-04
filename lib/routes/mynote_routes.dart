import 'package:get/get.dart';
import 'package:mynoteapps/bindings/binding.dart';

import 'package:mynoteapps/pages/login_page.dart';

class MyappRoute {
  static const login = '/login';
}
class AppPages {
  static final pages = [
    GetPage(name: MyappRoute.login, page: ()=>LoginPage(),binding: AppBinding()),
  ];
}