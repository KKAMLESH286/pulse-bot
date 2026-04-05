// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutStats)
const workoutStatsProvider = WorkoutStatsProvider._();

final class WorkoutStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkoutStats>,
          WorkoutStats,
          Stream<WorkoutStats>
        >
    with $FutureModifier<WorkoutStats>, $StreamProvider<WorkoutStats> {
  const WorkoutStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutStatsHash();

  @$internal
  @override
  $StreamProviderElement<WorkoutStats> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WorkoutStats> create(Ref ref) {
    return workoutStats(ref);
  }
}

String _$workoutStatsHash() => r'f32595f9e9dae0ad71bff574ddd27f263d9574ea';
