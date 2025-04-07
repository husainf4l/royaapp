import 'package:get/get.dart';
import 'package:royaapp/routes/navigation_page.dart';
import 'package:royaapp/Auth/login_screen.dart';
import 'package:royaapp/Auth/signup_screen.dart';
import 'package:royaapp/Auth/auth_middleware.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static final List<GetPage> pages = [
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const SignupScreen()),
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
