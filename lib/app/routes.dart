import 'package:get/get.dart';
import 'package:healthandwellness/features/home/presentation/home.dart';
import 'package:healthandwellness/features/login/presentation/login.dart';

import '../features/Service/presentation/service_view.dart';
import '../features/user_add/presentation/user_add.dart';

final List<GetPage<dynamic>> routes = [
GetPage(name: "/login", page:()=> Login()),
GetPage(name: "/home", page:()=> Home()),
GetPage(name: "/serviceview", page:()=> ServiceView()),
GetPage(name: "/useradd", page:()=> UserAdd()),
];