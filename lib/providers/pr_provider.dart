import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/personal_record.dart';
import '../services/pr_service.dart';
import 'auth_provider.dart';

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
