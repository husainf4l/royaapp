import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royaapp/routes/app_routes.dart';
import 'package:royaapp/Auth/auth_service.dart';
import 'package:royaapp/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Roya App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme(),
      initialRoute: _initialRoute,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fade,
    );
  }

  String get _initialRoute {
    final authService = Get.find<AuthService>();
    final isLoggedIn = authService.isLoggedIn.value;
    final route = AppRoutes.getInitialRoute(isLoggedIn);
    return route;
  }
}
