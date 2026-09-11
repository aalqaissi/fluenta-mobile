import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/models.dart';

/// Thrown for every API failure. `status == 0` means the network/host was
/// unreachable; `status == 401` means the session expired (token cleared).
class ApiException implements Exception {
  final int status;
  final String message;
  ApiException(this.status, this.message);
  @override
  String toString() => 'ApiException($status): $message';
}

class ApiClient {
  final AppConfig config;
  final http.Client _http;
  ApiClient(this.config, {http.Client? client}) : _http = client ?? http.Client();

  Future<T> _request<T>(
    String method,
    String path, {
    Object? body,
    required T Function(dynamic json) decode,
  }) async {
    final uri = Uri.parse('${config.serverUrl}$path');
    http.Response res;
    try {
      final request = http.Request(method, uri);
      final token = config.token;
      if (token != null) request.headers['Authorization'] = 'Bearer $token';
      if (body != null) {
        request.headers['Content-Type'] = 'application/json';
        request.body = jsonEncode(body);
      }
      res = await http.Response.fromStream(await _http.send(request));
    } catch (_) {
      throw ApiException(0,
          "Can't reach the Yalla English Hub API at ${config.serverUrl}. Is the backend running?");
    }

    if (res.statusCode == 401) {
      await config.setToken(null);
      throw ApiException(401, 'Your session has expired. Please sign in again.');
    }
    if (res.statusCode >= 400) {
      var msg = 'Request failed (${res.statusCode})';
      try {
        final data = jsonDecode(res.body);
        if (data is Map && data['error'] is String) msg = data['error'] as String;
      } catch (_) {/* keep default */}
      throw ApiException(res.statusCode, msg);
    }
    if (res.statusCode == 204 || res.body.isEmpty) return decode(null);
    return decode(jsonDecode(res.body));
  }

  Future<({String token, FluentaUser user})> login(String email) =>
      _request('POST', '/auth/login', body: {'email': email}, decode: (json) {
        final map = json as Map<String, dynamic>;
        return (
          token: map['token'] as String,
          user: FluentaUser.fromJson(map['user'] as Map<String, dynamic>),
        );
      });

  Future<void> logout() => _request('POST', '/auth/logout', decode: (_) {});

  Future<FluentaUser> getMe() => _request('GET', '/me',
      decode: (json) => FluentaUser.fromJson(json as Map<String, dynamic>));

  Future<FluentaUser> patchMe(Map<String, dynamic> patch) => _request('PATCH', '/me',
      body: patch,
      decode: (json) => FluentaUser.fromJson(json as Map<String, dynamic>));

  Future<Overview> getOverview() => _request('GET', '/overview',
      decode: (json) => Overview.fromJson(json as Map<String, dynamic>));
}
