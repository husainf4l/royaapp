import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royaapp/Auth/auth_controller.dart';
import 'package:royaapp/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Obx(() {
              // Reset error when rebuilding
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (controller.errorMessage.isNotEmpty) {
                  Future.delayed(const Duration(seconds: 3), () {
                    controller.resetError();
                  });
                }
              });

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // App logo
                    Image.asset(
                      'assets/images/logo.png', // Add this image to your assets
                      height: 100,
                      width: 100,
                      errorBuilder:
                          (context, error, stackTrace) => const Icon(
                            Icons.account_circle,
                            size: 100,
                            color: Colors.blueAccent,
                          ),
                    ),

                    const SizedBox(height: 20),

                    // Welcome text
                    const Text(
                      'مرحباً بعودتك',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Adjusted for dark theme
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'سجل الدخول للمتابعة',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey, // Subtle contrast for dark theme
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    // Email field - kept in English
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'example@email.com',
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.white70,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white70,
                            ), // Border for dark theme
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintStyle: const TextStyle(color: Colors.white38),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        enabled: !controller.isLoading.value,
                        style: const TextStyle(
                          color: Colors.white,
                        ), // Text color
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Password field - kept in English
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextField(
                        controller: controller.passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: '••••••••',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white70,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white70,
                            ), // Border for dark theme
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintStyle: const TextStyle(color: Colors.white38),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        enabled: !controller.isLoading.value,
                        style: const TextStyle(
                          color: Colors.white,
                        ), // Text color
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Forgot password link
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed:
                            controller.isLoading.value
                                ? null
                                : () {
                                  // Implement forgot password logic
                                },
                        child: const Text(
                          'نسيت كلمة المرور؟',
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ), // Highlighted for dark theme
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Error message
                    if (controller.errorMessage.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[900], // Darker red for dark theme
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[700]!),
                        ),
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(
                            color: Colors.white,
                          ), // White text for contrast
                          textAlign: TextAlign.center,
                        ),
                      ),

                    if (controller.errorMessage.isNotEmpty)
                      const SizedBox(height: 20),

                    // Login button
                    ElevatedButton(
                      onPressed:
                          controller.isLoading.value ? null : controller.login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor:
                            Colors.blueAccent, // Bright color for dark theme
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child:
                          controller.isLoading.value
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text(
                                'تسجيل الدخول',
                                style: TextStyle(fontSize: 16),
                              ),
                    ),

                    const SizedBox(height: 24),

                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("ليس لديك حساب؟"),
                        TextButton(
                          onPressed:
                              controller.isLoading.value
                                  ? null
                                  : () => Get.toNamed(AppRoutes.signup),
                          child: const Text('إنشاء حساب'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
