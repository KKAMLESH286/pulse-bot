// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(programContent)
const programContentProvider = ProgramContentProvider._();

final class ProgramContentProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, Stream<String?>>
    with $FutureModifier<String?>, $StreamProvider<String?> {
  const ProgramContentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'programContentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$programContentHash();

  @$internal
  @override
  $StreamProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String?> create(Ref ref) {
    return programContent(ref);
  }
}

String _$programContentHash() => r'c7081c54304c05146bfcc32a44c5294ab74f3e4b';
