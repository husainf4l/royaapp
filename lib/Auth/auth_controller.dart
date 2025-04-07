import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:royaapp/Auth/auth_service.dart';
import 'package:royaapp/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.onClose();
  }

  // Login method
  Future<void> login() async {
    if (!_validateLogin()) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (kDebugMode) {
        print('Starting login process...');
      }

      final response = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Accept both 200 and 201 as successful responses
      if (response.statusCode == 200 || response.statusCode == 201) {
        _clearControllers();

        // Ensure we give time for reactivity to update
        await Future.delayed(const Duration(milliseconds: 300));

        if (kDebugMode) {
          print('Login successful, navigating to home...');
          print('isLoggedIn: ${_authService.isLoggedIn.value}');
          print('User data: ${_authService.userData.value}');
        }

        Get.offAllNamed(AppRoutes.home);
      } else {
        if (kDebugMode) {
          print('Login failed with status: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        errorMessage.value =
            response.body?['message'] ?? 'Login failed. Please try again.';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      errorMessage.value = 'An error occurred. Please try again later.';
    } finally {
      isLoading.value = false;
    }
  }

  // Register method
  Future<void> register() async {
    if (!_validateRegister()) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _authService.register(
        email: emailController.text.trim(),
        password: passwordController.text,
        firstName: firstNameController.text.trim(),
        lastName: firstNameController.text.trim(),
      );

      // Accept both 200 and 201 as successful responses
      if (response.statusCode == 200 || response.statusCode == 201) {
        _clearControllers();

        // Ensure we give time for reactivity to update
        await Future.delayed(const Duration(milliseconds: 300));

        if (kDebugMode) {
          print('Registration successful, navigating to home...');
          print('isLoggedIn: ${_authService.isLoggedIn.value}');
          print('User data: ${_authService.userData.value}');
        }

        Get.offAllNamed(AppRoutes.home);
      } else {
        errorMessage.value =
            response.body?['message'] ??
            'Registration failed. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again later.';
    } finally {
      isLoading.value = false;
    }
  }

  // Logout method
  Future<void> logout() async {
    isLoading.value = true;
    await _authService.logout();
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.login);
  }

  // Reset error message
  void resetError() {
    errorMessage.value = '';
  }

  // Validate login inputs
  bool _validateLogin() {
    if (emailController.text.isEmpty) {
      errorMessage.value = 'Email is required.';
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      errorMessage.value = 'Please enter a valid email.';
      return false;
    }

    if (passwordController.text.isEmpty) {
      errorMessage.value = 'Password is required.';
      return false;
    }

    return true;
  }

  // Validate registration inputs
  bool _validateRegister() {
    if (firstNameController.text.isEmpty) {
      errorMessage.value = 'First name is required.';
      return false;
    }

    if (lastNameController.text.isEmpty) {
      errorMessage.value = 'Last name is required.';
      return false;
    }

    if (emailController.text.isEmpty) {
      errorMessage.value = 'Email is required.';
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      errorMessage.value = 'Please enter a valid email.';
      return false;
    }

    if (passwordController.text.isEmpty) {
      errorMessage.value = 'Password is required.';
      return false;
    }

    if (passwordController.text.length < 6) {
      errorMessage.value = 'Password should be at least 6 characters.';
      return false;
    }

    return true;
  }

  // Clear text controllers
  void _clearControllers() {
    emailController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
  }
}
