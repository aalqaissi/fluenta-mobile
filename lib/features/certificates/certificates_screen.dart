import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/brand.dart';
import '../../models/models.dart';
import '../../services/api_client.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});
  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  late Future<List<CertificateDto>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<AuthState>().api.getCertificates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Certificates')),
      body: FutureBuilder<List<CertificateDto>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: EmptyStateView(
                  icon: Icons.cloud_off_rounded,
                  title: 'Certificates unavailable',
                  description: snap.error is ApiException
                      ? (snap.error as ApiException).message
                      : 'Could not load certificates.',
                  action: FilledButton(
                    onPressed: () => setState(() =>
                        _future = context.read<AuthState>().api.getCertificates()),
                    child: const Text('Retry'),
                  ),
                ),
              ),
            );
          }
          final certs = snap.data!;
          if (certs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: EmptyStateView(
                  icon: Icons.workspace_premium_outlined,
                  title: 'No certificates yet',
                  description: 'Complete a full practice test to earn a Test Report Form.',
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [for (final c in certs) _card(c)],
          );
        },
      ),
    );
  }

  Widget _card(CertificateDto c) {
    final isReport = c.type == 'ielts-report';
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: FluentaCard(
        padding: EdgeInsets.zero,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: AppColors.warmGradient,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(children: [
              const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                  Text(isReport ? 'IELTS-style Test Report Form' : 'Standard certificate',
                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ]),
              ),
              Column(children: [
                Text(formatBand(c.overall),
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                Text(c.cefr, style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ]),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (c.scores.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final k in const ['listening', 'reading', 'writing', 'speaking'])
                      _score(k, c.scores[k]),
                  ],
                ),
              const SizedBox(height: 12),
              Row(children: [
                const Icon(Icons.verified_outlined, size: 15, color: AppColors.mutedForeground),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(c.verificationNumber.isEmpty ? '—' : c.verificationNumber,
                      style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
                ),
                Text(c.issuedOn, style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
              ]),
              const SizedBox(height: 6),
              Text('Practice certificate — not an official result. Issued by ${Brand.name}.',
                  style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _score(String label, double? band) {
    return Column(children: [
      Text(band == null ? '—' : formatBand(band),
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.bandTone(band))),
      Text(label[0].toUpperCase() + label.substring(1, 1 + 3),
          style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
    ]);
  }
}
