import 'package:get/get.dart';
import '0_routes_lib.dart';

class Routers{
  static final routes = [
    GetPage(name: "/HomePage", page: () => const HomePage()),
    GetPage(name: "/LoginPage", page: () => const LoginPage()),
    GetPage(name: "/RegisterPage", page: () => const RegisterPage()),
    GetPage(name: "/AddDevicePage", page: () => const AddDevicePage()),
    GetPage(name: "/AddSensorPage", page: () => const AddSensorPage()),
    GetPage(name: "/TermAndConditionPage", page: () => const TermAndConditionPage()),
    GetPage(name: "/PrivacyPolicyPage", page: () => const PrivacyPolicyPage()),
  ];
}