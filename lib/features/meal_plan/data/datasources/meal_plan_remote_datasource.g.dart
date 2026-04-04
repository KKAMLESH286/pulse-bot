// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mealPlanRemoteDatasource)
const mealPlanRemoteDatasourceProvider = MealPlanRemoteDatasourceProvider._();

final class MealPlanRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          MealPlanRemoteDatasource,
          MealPlanRemoteDatasource,
          MealPlanRemoteDatasource
        >
    with $Provider<MealPlanRemoteDatasource> {
  const MealPlanRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealPlanRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealPlanRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<MealPlanRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MealPlanRemoteDatasource create(Ref ref) {
    return mealPlanRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MealPlanRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MealPlanRemoteDatasource>(value),
    );
  }
}

String _$mealPlanRemoteDatasourceHash() =>
    r'b33f38d25fd3e9a63a52d89fd91cb4efebdbe34c';
