class AppConfig {
  static const String baseUrl = 'http://192.168.1.110:4001';
  static const String apiUrl = '$baseUrl/auth';

  // Webhook configuration
  static String webhookUrl =
      'https://roxateltd.app.n8n.cloud/webhook-test/roya34-upload';

  // App information
  static const String appVersion = '1.0.0';
  static const bool debugMode = true;
}
