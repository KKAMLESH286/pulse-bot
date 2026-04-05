// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(streakDatasource)
const streakDatasourceProvider = StreakDatasourceProvider._();

final class StreakDatasourceProvider
    extends
        $FunctionalProvider<
          StreakDatasource,
          StreakDatasource,
          StreakDatasource
        >
    with $Provider<StreakDatasource> {
  const StreakDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streakDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streakDatasourceHash();

  @$internal
  @override
  $ProviderElement<StreakDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StreakDatasource create(Ref ref) {
    return streakDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreakDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StreakDatasource>(value),
    );
  }
}

String _$streakDatasourceHash() => r'd6092dda9e3c494c6e992b3f3e3f978258ff500c';
