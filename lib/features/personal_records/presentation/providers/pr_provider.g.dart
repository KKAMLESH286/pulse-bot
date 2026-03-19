// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pr_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(prService)
const prServiceProvider = PrServiceProvider._();

final class PrServiceProvider
    extends $FunctionalProvider<PRService, PRService, PRService>
    with $Provider<PRService> {
  const PrServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prServiceHash();

  @$internal
  @override
  $ProviderElement<PRService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PRService create(Ref ref) {
    return prService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PRService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PRService>(value),
    );
  }
}

String _$prServiceHash() => r'd3272085f6a9b7ccc4c8fa1cff6c7a05812d1d8a';

@ProviderFor(personalRecords)
const personalRecordsProvider = PersonalRecordsProvider._();

final class PersonalRecordsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PersonalRecord>>,
          List<PersonalRecord>,
          Stream<List<PersonalRecord>>
        >
    with
        $FutureModifier<List<PersonalRecord>>,
        $StreamProvider<List<PersonalRecord>> {
  const PersonalRecordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personalRecordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personalRecordsHash();

  @$internal
  @override
  $StreamProviderElement<List<PersonalRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PersonalRecord>> create(Ref ref) {
    return personalRecords(ref);
  }
}

String _$personalRecordsHash() => r'561ec5e13cd0448a1ceb881c8a8a757793f36e90';
