import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/models/paw_patrol_report.dart';
import 'package:pawcity/repositories/paw_patrol_repository.dart';

final pawPatrolRepositoryProvider = Provider<PawPatrolRepository>((ref) {
  return PawPatrolRepository();
});

final pawPatrolReportsProvider =
    FutureProvider<List<PawPatrolReport>>((ref) async {
  final repo = ref.watch(pawPatrolRepositoryProvider);
  return repo.fetchReports();
});

final pawPatrolReportDetailProvider =
    FutureProvider.family<PawPatrolReport, String>((ref, reportId) async {
  final repo = ref.watch(pawPatrolRepositoryProvider);
  return repo.fetchReport(reportId);
});
