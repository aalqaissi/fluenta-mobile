import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../mock/data.dart';
import 'auth_state.dart';

/// App-level preferences. The current user + auth live in [AuthState];
/// AppState delegates `user`/plan lookups to it once [bind] is called.
class AppState extends ChangeNotifier {
  AuthState? _auth;
  bool _previewFree = false;
  String track = 'ielts';

  /// Wire this AppState to the AuthState so `user` reflects the signed-in
  /// account and consumers rebuild when auth changes.
  void bind(AuthState auth) {
    _auth = auth;
    auth.addListener(notifyListeners);
  }

  FluentaUser get user => _auth?.user ?? currentUser;
  bool get previewFree => _previewFree;

  PlanTier get effectivePlan => _previewFree ? PlanTier.free : user.plan;
  bool get isPro => effectivePlan == PlanTier.pro;

  /// listening / speaking / full-exam are locked on the free tier.
  bool isLocked(String key) {
    if (effectivePlan == PlanTier.pro) return false;
    return key == 'listening' || key == 'speaking' || key == 'full-exam';
  }

  void setPreviewFree(bool v) {
    _previewFree = v;
    notifyListeners();
  }

  // These now persist through the API (PATCH /me) via AuthState.
  void setExamDate(DateTime date, double targetBand) {
    _auth?.updateMe({
      'examDate': date.toIso8601String().split('T').first,
      'targetBand': targetBand,
    });
  }

  void clearExamDate() => _auth?.updateMe({'examDate': ''});

  void setSaveHistory(bool v) => _auth?.updateMe({'saveHistory': v});
}
