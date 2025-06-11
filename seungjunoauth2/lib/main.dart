import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final FlutterAppAuth appAuth = FlutterAppAuth();
final AuthorizationServiceConfiguration serviceConfig =
    AuthorizationServiceConfiguration(
      authorizationEndpoint: 'https://api.intra.42.fr/oauth/authorize',
      tokenEndpoint: 'https://api.intra.42.fr/oauth/token',
    );

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<void> _login() async {
    try {
      final AuthorizationTokenResponse
      result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          'u-s4t2ud-f01bad212d59b7943e19fa664764d01102f620aae5dddb162eaa752dffbbdbdd',
          'seungjunlogin://oauthredirect',
          clientSecret:
              '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',
          serviceConfiguration: serviceConfig,
          scopes: ['public'],
        ),
      );
      debugPrint('access Token: ${result.accessToken}');
      debugPrint('Refresh Token: ${result.refreshToken}');
      final url = Uri.parse('https://api.intra.42.fr/v2/me');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${result.accessToken}'},
      );
      if (response.statusCode == 200) {
        debugPrint('success fetch user information');
        final Map<String, dynamic> userData = json.decode(response.body);
        debugPrint(userData.toString());
      }
    } catch (e) {
      debugPrint('login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('hello'),
              ElevatedButton(onPressed: _login, child: Text('login')),
            ],
          ),
        ),
      ),
    );
  }
}
