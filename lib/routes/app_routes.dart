import 'package:get/get.dart';
import 'package:royaapp/routes/navigation_page.dart';
import 'package:royaapp/Auth/login_screen.dart';
import 'package:royaapp/Auth/signup_screen.dart';
import 'package:royaapp/Auth/auth_middleware.dart';
import 'package:royaapp/Auth/auth_binding.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static final List<GetPage> pages = [
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: signup,
      page: () => const SignupScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: home,
      page: () => const NavigationPage(),
      middlewares: [AuthMiddleware()],
    ),
  ];

  static String getInitialRoute(bool isLoggedIn) {
    return isLoggedIn ? home : login;
  }
}
