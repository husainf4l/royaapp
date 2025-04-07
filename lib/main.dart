import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royaapp/routes/app_routes.dart';
import 'package:royaapp/Auth/auth_service.dart';
import 'package:royaapp/theme/app_theme.dart';

// Initialize services before app starts
Future<void> initServices() async {
  debugPrint('Initializing services...');
  await Get.putAsync(() => AuthService().init());
  debugPrint('All services initialized');
}

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
      showPerformanceOverlay: false, // Disable performance overlay
      debugShowMaterialGrid: false, // Disable material grid
    );
  }

  String get _initialRoute {
    final authService = Get.find<AuthService>();
    final isLoggedIn = authService.isLoggedIn.value;

    // Debugging logs
    // ignore: unnecessary_null_comparison
    debugPrint('AuthService initialized: ${authService != null}');
    debugPrint('User is logged in: $isLoggedIn');

    final route = AppRoutes.getInitialRoute(isLoggedIn);
    debugPrint('Initial route selected: $route');

    return route;
  }
}
