import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../models/models.dart';
import '../services/api_client.dart';

enum BootStatus { booting, offline, unauthed, ready }

/// Source of truth for authentication + the current user + app bootstrap.
class AuthState extends ChangeNotifier {
  final AppConfig config;
  final ApiClient api;
  AuthState({required this.config, required this.api});

  BootStatus _status = BootStatus.booting;
  FluentaUser? _user;
  String? _error;

  BootStatus get status => _status;
  FluentaUser? get user => _user;
  String? get error => _error;
  bool get isAuthed => _user != null;

  Future<void> bootstrap() async {
    _status = BootStatus.booting;
    _error = null;
    notifyListeners();
    if (config.token == null) {
      _status = BootStatus.unauthed;
      notifyListeners();
      return;
    }
    try {
      _user = await api.getMe();
      _status = BootStatus.ready;
    } on ApiException catch (e) {
      if (e.status == 0) {
        _status = BootStatus.offline;
        _error = e.message;
      } else {
        _user = null;
        _status = BootStatus.unauthed;
      }
    }
    notifyListeners();
  }

  Future<void> login(String email) async {
    final result = await api.login(email);
    await config.setToken(result.token);
    _user = result.user;
    _error = null;
    _status = BootStatus.ready;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await api.logout();
    } catch (_) {/* ignore network errors on logout */}
    await config.setToken(null);
    _user = null;
    _status = BootStatus.unauthed;
    notifyListeners();
  }

  Future<void> updateMe(Map<String, dynamic> patch) async {
    _user = await api.patchMe(patch);
    notifyListeners();
  }

  Future<void> retry() => bootstrap();
}
