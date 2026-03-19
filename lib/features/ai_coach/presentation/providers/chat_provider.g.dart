// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream of chat messages from Firestore (real-time updates).

@ProviderFor(chatMessages)
const chatMessagesProvider = ChatMessagesProvider._();

/// Stream of chat messages from Firestore (real-time updates).

final class ChatMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatMessage>>,
          List<ChatMessage>,
          Stream<List<ChatMessage>>
        >
    with
        $FutureModifier<List<ChatMessage>>,
        $StreamProvider<List<ChatMessage>> {
  /// Stream of chat messages from Firestore (real-time updates).
  const ChatMessagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatMessagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatMessagesHash();

  @$internal
  @override
  $StreamProviderElement<List<ChatMessage>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatMessage>> create(Ref ref) {
    return chatMessages(ref);
  }
}

String _$chatMessagesHash() => r'5b9ec8702a93ba66e2b2ab0becb1946d64ae27ba';

/// Whether the AI coach is currently processing a message.

@ProviderFor(isChatProcessing)
const isChatProcessingProvider = IsChatProcessingProvider._();

/// Whether the AI coach is currently processing a message.

final class IsChatProcessingProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the AI coach is currently processing a message.
  const IsChatProcessingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isChatProcessingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isChatProcessingHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isChatProcessing(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isChatProcessingHash() => r'fc0eb5fa6fb10fac051d0f0112fed65771d9bfeb';

/// Send a message to the AI coach via Cloud Function.
/// Returns the assistant's response text.

@ProviderFor(CoachNotifier)
const coachProvider = CoachNotifierProvider._();

/// Send a message to the AI coach via Cloud Function.
/// Returns the assistant's response text.
final class CoachNotifierProvider
    extends $NotifierProvider<CoachNotifier, bool> {
  /// Send a message to the AI coach via Cloud Function.
  /// Returns the assistant's response text.
  const CoachNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coachProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coachNotifierHash();

  @$internal
  @override
  CoachNotifier create() => CoachNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$coachNotifierHash() => r'9be9ea19b1ff4eb9215f7406f8a8eab7b3f97e38';

/// Send a message to the AI coach via Cloud Function.
/// Returns the assistant's response text.

abstract class _$CoachNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
