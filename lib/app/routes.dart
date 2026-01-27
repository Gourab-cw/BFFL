import 'package:get/get.dart';
import 'package:healthandwellness/features/home/presentation/home.dart';
import 'package:healthandwellness/features/login/presentation/login.dart';

final List<GetPage<dynamic>> routes = [
GetPage(name: "/login", page:()=> Login()),
GetPage(name: "/home", page:()=> Home()),
];