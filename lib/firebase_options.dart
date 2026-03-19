import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyArCCSq-cHgdEj5Wxqh8RGPhNPMFip8vqk',
    appId: '1:263697899480:web:8710907c9a108596c41cad',
    messagingSenderId: '263697899480',
    projectId: 'gain-bot-4df1d',
    authDomain: 'gain-bot-4df1d.firebaseapp.com',
    storageBucket: 'gain-bot-4df1d.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDF-PzL7j2fcMxCFfcE5nKHJTpGuOGJJQ',
    appId: '1:263697899480:android:dfa0ddda06c70ff3c41cad',
    messagingSenderId: '263697899480',
    projectId: 'gain-bot-4df1d',
    storageBucket: 'gain-bot-4df1d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCaLnK2q7ru85KWK_jqz99-n8VrHXkFZlE',
    appId: '1:263697899480:ios:6e72c44c9c17ab35c41cad',
    messagingSenderId: '263697899480',
    projectId: 'gain-bot-4df1d',
    storageBucket: 'gain-bot-4df1d.firebasestorage.app',
    iosBundleId: 'com.example.trackMe',
  );
}
