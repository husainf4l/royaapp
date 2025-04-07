import 'package:get/get.dart';
import 'package:royaapp/Auth/auth_controller.dart';
import 'package:royaapp/Auth/auth_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Register AuthService if not already registered
    if (!Get.isRegistered<AuthService>()) {
      Get.put(AuthService(), permanent: true);
    }

    // Register AuthController
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
