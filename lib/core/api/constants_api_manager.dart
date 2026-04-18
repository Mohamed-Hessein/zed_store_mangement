import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String baseUrl = "https://api.zid.sa";

  static String clientId = dotenv.get('ZID_CLIENT_ID', fallback: '0000');

  static String redirectUri = dotenv.get('ZID_REDIRECT_URI', fallback: ''); }
