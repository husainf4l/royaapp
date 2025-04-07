import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:royaapp/Auth/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
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
                  const Text(
                    'Join Us',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // First Name field
                  TextField(
                    controller: controller.firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    enabled: !controller.isLoading.value,
                  ),

                  const SizedBox(height: 16),

                  // Last Name field
                  TextField(
                    controller: controller.lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    enabled: !controller.isLoading.value,
                  ),

                  const SizedBox(height: 16),

                  // Email field
                  TextField(
                    controller: controller.emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !controller.isLoading.value,
                  ),

                  const SizedBox(height: 16),

                  // Password field
                  TextField(
                    controller: controller.passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    enabled: !controller.isLoading.value,
                  ),

                  const SizedBox(height: 24),

                  // Error message
                  if (controller.errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  if (controller.errorMessage.isNotEmpty)
                    const SizedBox(height: 16),

                  // Register button
                  ElevatedButton(
                    onPressed:
                        controller.isLoading.value ? null : controller.register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child:
                        controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : const Text(
                              'Create Account',
                              style: TextStyle(fontSize: 16),
                            ),
                  ),

                  const SizedBox(height: 16),

                  // Terms and conditions
                  const Text(
                    'By signing up, you agree to our Terms of Service and Privacy Policy.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
