import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/models/models.dart';

const _userJson = {
  'id': 'u1', 'name': 'Sara Hamzeh', 'email': 'sara@example.com',
  'initials': 'SH', 'avatarUrl': '', 'plan': 'pro', 'planLabel': 'Pro Monthly',
  'renewsInDays': 7, 'targetBand': 7.0, 'examDate': '2026-12-01',
  'saveHistory': true, 'track': 'ielts', 'examType': 'IELTS (Academic)',
  'purpose': 'Study Abroad', 'level': 'upper-intermediate', 'onboarded': true,
  'streak': {'current': 4, 'best': 11, 'last30': [0, 1, 2, 3]},
};

void main() {
  test('fromJson parses the full backend user shape', () {
    final u = FluentaUser.fromJson(Map<String, dynamic>.from(_userJson));
    expect(u.id, 'u1');
    expect(u.plan, PlanTier.pro);
    expect(u.targetBand, 7.0);
    expect(u.examDate, DateTime(2026, 12, 1));
    expect(u.onboarded, isTrue);
    expect(u.track, 'ielts');
    expect(u.streak.best, 11);
    expect(u.streak.last30, [0, 1, 2, 3]);
  });

  test('fromJson tolerates a null examDate and missing initials', () {
    final json = Map<String, dynamic>.from(_userJson)
      ..['examDate'] = null
      ..remove('initials')
      ..['plan'] = 'free';
    final u = FluentaUser.fromJson(json);
    expect(u.examDate, isNull);
    expect(u.plan, PlanTier.free);
    expect(u.initials, 'SH'); // derived from "Sara Hamzeh"
  });

  test('toJson round-trips examDate as a plain ISO date and plan as a string', () {
    final u = FluentaUser.fromJson(Map<String, dynamic>.from(_userJson));
    final json = u.toJson();
    expect(json['plan'], 'pro');
    expect(json['examDate'], '2026-12-01');
    expect(json['onboarded'], true);
  });
}
