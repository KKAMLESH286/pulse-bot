// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutService)
const workoutServiceProvider = WorkoutServiceProvider._();

final class WorkoutServiceProvider
    extends $FunctionalProvider<WorkoutService, WorkoutService, WorkoutService>
    with $Provider<WorkoutService> {
  const WorkoutServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutServiceHash();

  @$internal
  @override
  $ProviderElement<WorkoutService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WorkoutService create(Ref ref) {
    return workoutService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutService>(value),
    );
  }
}

String _$workoutServiceHash() => r'97c5f55afd518791e0342c6ee8d1b5046b8ab620';

@ProviderFor(workoutEntries)
const workoutEntriesProvider = WorkoutEntriesProvider._();

final class WorkoutEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WorkoutEntry>>,
          List<WorkoutEntry>,
          Stream<List<WorkoutEntry>>
        >
    with
        $FutureModifier<List<WorkoutEntry>>,
        $StreamProvider<List<WorkoutEntry>> {
  const WorkoutEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutEntriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutEntriesHash();

  @$internal
  @override
  $StreamProviderElement<List<WorkoutEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WorkoutEntry>> create(Ref ref) {
    return workoutEntries(ref);
  }
}

String _$workoutEntriesHash() => r'bebafdc043f1968e69bd4a7b0599b05d28c3f9f6';
