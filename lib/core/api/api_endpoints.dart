import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const String _ipAddress = '192.168.10.74';
  static const int _port = 5050;

  static String get _host {
    if (kIsWeb) return 'localhost';

    if (Platform.isAndroid) {
      return _ipAddress;
    }

    if (Platform.isIOS) return _ipAddress;

    return 'localhost';
  }

  static String get serverUrl => 'http://$_host:$_port';
  static String get baseUrl => '$serverUrl/api';
  static String get mediaServerUrl => serverUrl;

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String user = '/profile';
  static String userById(String id) => '/profile/$id';

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String profile = '/auth/profile';

  static const String uploadProfilePicture = '/profile/upload-profile-picture';
  static String profilePicture(String filename) =>
      '$mediaServerUrl/profile_pictures/$filename';

  static const String tournaments = '/tournaments';
  static String tournamentById(String id) => '/tournaments/$id';
  static const String myTournaments = '/tournaments/user/my-tournaments';
  static String tournamentBanner(String filename) =>
      '$mediaServerUrl/tournament_banners/$filename';
}
