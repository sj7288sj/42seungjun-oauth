import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart';

final FlutterAppAuth appAuth = FlutterAppAuth();
final AuthorizationServiceConfiguration
serviceConfig = AuthorizationServiceConfiguration(
  authorizationEndpoint:
      'https://api.intra.42.fr/oauth/authorize',
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
          'com.example.seungjun42oauth2://oauthredirect',
          serviceConfiguration: serviceConfig,
          scopes: ['public'],
        ),
      );
      debugPrint('access Token: ${result.accessToken}');
      debugPrint('Refresh Token: ${result.refreshToken}');
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
