import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:track_me/features/personal_records/data/models/personal_record_model.dart';
import 'package:track_me/features/personal_records/data/services/pr_service.dart';
import 'package:track_me/features/auth/presentation/providers/auth_provider.dart';

part 'pr_provider.g.dart';

@Riverpod(keepAlive: true)
PRService prService(Ref ref) {
  return PRService();
}

@riverpod
Stream<List<PersonalRecord>> personalRecords(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref
      .watch(prServiceProvider)
      .prsStream(user.uid)
      .map((snap) => snap.docs.map(PersonalRecord.fromFirestore).toList());
}
