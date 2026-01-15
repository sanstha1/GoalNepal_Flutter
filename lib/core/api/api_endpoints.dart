class ApiEndpoints {
  ApiEndpoints._();

  // ================= Base URL =================
  // Android Emulator
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // iOS Simulator
  // static const String baseUrl = 'http://localhost:5000/api';

  // Physical device (use your PC IP)
  // static const String baseUrl = 'http://192.168.1.100:5000/api';

  // ================= Timeouts =================
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ================= Auth Endpoints =================
  static const String register = '/auth/register';
  static const String login = '/auth/login';

  // ================= User =================
  static const String profile = '/users/profile';
}
