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

@ProviderFor(workoutLogs)
const workoutLogsProvider = WorkoutLogsProvider._();

final class WorkoutLogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WorkoutLog>>,
          List<WorkoutLog>,
          Stream<List<WorkoutLog>>
        >
    with $FutureModifier<List<WorkoutLog>>, $StreamProvider<List<WorkoutLog>> {
  const WorkoutLogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutLogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutLogsHash();

  @$internal
  @override
  $StreamProviderElement<List<WorkoutLog>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WorkoutLog>> create(Ref ref) {
    return workoutLogs(ref);
  }
}

String _$workoutLogsHash() => r'b7ecba3fcf9586f894377333b5be1ec9f2310cbf';
