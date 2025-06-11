import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

final FlutterAppAuth appAuth = FlutterAppAuth();
final AuthorizationServiceConfiguration serviceConfig =
    AuthorizationServiceConfiguration(
      authorizationEndpoint: 'https://api.intra.42.fr/oauth/authorize',
      tokenEndpoint: 'https://api.intra.42.fr/oauth/token',
    );

void main() async {
  await dotenv.load();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String? _accessToken;
  Map<String, dynamic>? _userInfo;

  Future<Map<String, dynamic>> fetchUserInfo(String accessToken) async {
    final url = Uri.parse('https://api.intra.42.fr/v2/me');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('fail fetch user info');
    }
  }

  Future<void> _login() async {
    try {
      final AuthorizationTokenResponse
      result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          '${dotenv.env['CLIENT_UID']}',
          'seungjunoauth://oauthredirect',
          clientSecret:
              '${dotenv.env['SECRET_KEY']}',
          serviceConfiguration: serviceConfig,
          scopes: ['public'],
        ),
      );
      debugPrint('access Token: ${result.accessToken}');
      debugPrint('Refresh Token: ${result.refreshToken}');
      if (result.accessToken != null) {
        final userInfo = await fetchUserInfo(result.accessToken!);
        setState(() {
          _accessToken = result.accessToken;
          _userInfo = userInfo;
        });
      }
      debugPrint(_userInfo.toString());
    } catch (e) {
      debugPrint('login failed: $e');
    }
  }

  Future<void> _logout() async {
    try {
      
    } catch (e) {
      debugPrint('something went wrong: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = _accessToken != null;

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('hello'),
              ElevatedButton(
                onPressed: !isLoggedIn ? _login : null,
                child: Text('login'),
              ),
              isLoggedIn ? Text(_userInfo!['login']) : SizedBox(),
              isLoggedIn
                  ? ElevatedButton(onPressed: _logout, child: Text('logout'))
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
