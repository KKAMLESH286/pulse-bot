// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(coachRemoteDatasource)
const coachRemoteDatasourceProvider = CoachRemoteDatasourceProvider._();

final class CoachRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          CoachRemoteDatasource,
          CoachRemoteDatasource,
          CoachRemoteDatasource
        >
    with $Provider<CoachRemoteDatasource> {
  const CoachRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coachRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coachRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<CoachRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoachRemoteDatasource create(Ref ref) {
    return coachRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoachRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoachRemoteDatasource>(value),
    );
  }
}

String _$coachRemoteDatasourceHash() =>
    r'08952980b525b4f4a1458f4bb8e5ca1c3ec5af1d';
