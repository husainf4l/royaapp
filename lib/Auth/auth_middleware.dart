import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royaapp/Auth/auth_service.dart';
import 'package:royaapp/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();

    if (!authService.isLoggedIn.value &&
        route != AppRoutes.login &&
        route != AppRoutes.signup) {
      return const RouteSettings(name: AppRoutes.login);
    }

    if (authService.isLoggedIn.value &&
        (route == AppRoutes.login || route == AppRoutes.signup)) {
      return const RouteSettings(name: AppRoutes.home);
    }

    return null;
  }
}
