// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mealPlanStream)
const mealPlanStreamProvider = MealPlanStreamProvider._();

final class MealPlanStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<MealPlanModel?>,
          MealPlanModel?,
          Stream<MealPlanModel?>
        >
    with $FutureModifier<MealPlanModel?>, $StreamProvider<MealPlanModel?> {
  const MealPlanStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealPlanStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealPlanStreamHash();

  @$internal
  @override
  $StreamProviderElement<MealPlanModel?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<MealPlanModel?> create(Ref ref) {
    return mealPlanStream(ref);
  }
}

String _$mealPlanStreamHash() => r'38ad56e2a01c7645eb043df0cf8cdb8a44901d54';

@ProviderFor(MealPlanUploader)
const mealPlanUploaderProvider = MealPlanUploaderProvider._();

final class MealPlanUploaderProvider
    extends $AsyncNotifierProvider<MealPlanUploader, void> {
  const MealPlanUploaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealPlanUploaderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealPlanUploaderHash();

  @$internal
  @override
  MealPlanUploader create() => MealPlanUploader();
}

String _$mealPlanUploaderHash() => r'061a0b4b8d7413ef8cb54bd7fa463b79e436245f';

abstract class _$MealPlanUploader extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
