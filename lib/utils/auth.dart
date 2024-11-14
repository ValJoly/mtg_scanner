import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.1.72:3000';

/// login with username and password
/// return a token if the request is successful
/// return null if the request fails
Future<String?> loginWithEmailPassword(String username, String password) async {
  http.Response response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );
  if (response.statusCode != 200) {
    log('Error logging in with email and password: ${response.body}');
    return null;
  }
  var token = jsonDecode(response.body)['token'];
  return token;
}

/// register with username and password
/// return a token if the request is successful
/// return null if the request fails
/// return 'user already exists' if the user already exists (status code 400)

Future<String?> registerWithEmailPassword(
    String username, String password) async {
  http.Response response = await http.post(
    Uri.parse(
      '$baseUrl/auth/register',
    ),
    headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );
  if (response.statusCode == 400) {
    log('User already exists');
    return 'user already exists';
  }
  // if user register successfully, status code is 201
  if (response.statusCode != 201) {
    log('Error registering with email and password: ${response.body}');
    return null;
  }
  log('Registered with email and password');
  var token = await loginWithEmailPassword(username, password);

  return token;
}
