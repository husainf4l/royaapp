import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:royaapp/config/app_config.dart';
import 'package:royaapp/Auth/auth_controller.dart';

class AuthService extends GetxService {
  final GetStorage _storage = GetStorage();
  final String _tokenKey = 'auth_token';
  final String _refreshTokenKey = 'refresh_token';
  final String _userDataKey = 'user_data';

  final Rx<bool> isLoggedIn = false.obs;
  final Rxn<Map<String, dynamic>> userData = Rxn<Map<String, dynamic>>();

  final _httpClient = GetConnect();

  Future<AuthService> init() async {
    await GetStorage.init();
    String? token = getToken();
    isLoggedIn.value = token != null;

    // Load user data if available
    if (isLoggedIn.value) {
      userData.value = getUserData();
    }

    _setupInterceptors();
    return this;
  }

  void _setupInterceptors() {
    _httpClient.httpClient.addRequestModifier<dynamic>((request) {
      String? token = getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    _httpClient.httpClient.addResponseModifier((request, response) async {
      if (response.statusCode == 401) {
        bool refreshed = await refreshToken();
        if (refreshed) {
          String? newToken = getToken();
          request.headers['Authorization'] = 'Bearer $newToken';
          return _httpClient.httpClient.request(
            request.url.toString(),
            request.method,
            body: request.bodyBytes,
            headers: request.headers,
            contentType: request.headers['content-type'],
          );
        }
      }
      return response;
    });
  }

  Future<Response> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _httpClient.post('${AppConfig.apiUrl}/register', {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      });

      // Accept both 200 and 201 as successful responses
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Similar structure to login success handler
        if (response.body is Map) {
          if (response.body['accessToken'] != null) {
            _saveTokens({
              'token': response.body['accessToken'],
              'refresh_token': response.body['refreshToken'],
            });
          } else {
            _saveTokens(response.body);
          }

          if (response.body['user'] != null) {
            _saveUserData({'user': response.body['user']});
          } else {
            _saveUserData(response.body);
          }
        }

        isLoggedIn.value = true;
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Register error: $e');
      }
      return Response(statusCode: 500, statusText: 'Server error');
    }
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpClient.post('${AppConfig.apiUrl}/login', {
        'email': email,
        'password': password,
      });

      // Accept both 200 and 201 as successful responses
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('Login successful. Processing data...');
        }

        // Check the response structure based on the log
        if (response.body is Map) {
          // Extract token from correct field name based on your API
          if (response.body['accessToken'] != null) {
            // Update the _saveTokens method to handle this structure
            _saveTokens({
              'token': response.body['accessToken'],
              'refresh_token': response.body['refreshToken'],
            });
          } else {
            _saveTokens(response.body);
          }

          // Save user data - this field name appears correct in your log
          if (response.body['user'] != null) {
            _saveUserData({'user': response.body['user']});
          } else {
            _saveUserData(response.body);
          }
        }

        isLoggedIn.value = true;
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      return Response(statusCode: 500, statusText: 'Server error');
    }
  }

  Future<bool> refreshToken() async {
    try {
      String? refreshToken = _storage.read(_refreshTokenKey);
      if (refreshToken == null) return false;

      final response = await _httpClient.post(
        '${AppConfig.apiUrl}/refresh-token',
        {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        _saveTokens(response.body);
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Refresh token error: $e');
      }
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _httpClient.post('${AppConfig.apiUrl}/logout', {});
    } catch (e) {
      if (kDebugMode) {
        print('Logout error: $e');
      }
    } finally {
      // Clear tokens and user data regardless of server response
      _storage.remove(_tokenKey);
      _storage.remove(_refreshTokenKey);
      _storage.remove(_userDataKey);
      userData.value = null;
      isLoggedIn.value = false;
    }
  }

  void _saveTokens(dynamic responseBody) {
    if (responseBody is Map) {
      // Save access token - could be under 'token' or 'accessToken'
      String? token = responseBody['token'] ?? responseBody['accessToken'];
      if (token != null) {
        _storage.write(_tokenKey, token);
        if (kDebugMode) {
          print('Token saved');
        }
      }

      // Save refresh token - could be under 'refresh_token' or 'refreshToken'
      String? refreshToken =
          responseBody['refresh_token'] ?? responseBody['refreshToken'];
      if (refreshToken != null) {
        _storage.write(_refreshTokenKey, refreshToken);
        if (kDebugMode) {
          print('Refresh token saved');
        }
      }
    }
  }

  void _saveUserData(dynamic responseBody) {
    if (responseBody is Map) {
      // Check if the response contains user directly or within a data structure
      Map<String, dynamic> userMap = {};

      if (responseBody.containsKey('user')) {
        userMap = Map<String, dynamic>.from(responseBody['user']);
      } else if (responseBody.containsKey('data') &&
          responseBody['data'] is Map) {
        userMap = Map<String, dynamic>.from(responseBody['data']);
      } else {
        // Try to extract user-like data from the response
        if (responseBody.containsKey('first_name') ||
            responseBody.containsKey('email') ||
            responseBody.containsKey('id')) {
          userMap = Map<String, dynamic>.from(responseBody);
        }
      }

      if (userMap.isNotEmpty) {
        _storage.write(_userDataKey, userMap);
        userData.value = userMap;
        if (kDebugMode) {
          print('User data saved: $userMap');
        }
      }
    }
  }

  String? getToken() => _storage.read(_tokenKey);

  Map<String, dynamic>? getUserData() => _storage.read(_userDataKey);

  String? getUserFirstName() {
    final data = getUserData();
    return data != null ? data['first_name'] : null;
  }
}

// Modify initialization to avoid circular dependency
Future<void> initServices() async {
  await GetStorage.init();
  await Get.putAsync(() => AuthService().init(), permanent: true);

  await Future.delayed(const Duration(milliseconds: 100));
  if (!Get.isRegistered<AuthController>()) {
    Get.put(AuthController(), permanent: true);
  }
}
