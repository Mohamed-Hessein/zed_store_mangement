

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
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBhBIGcyVMcxfdG1ekLsYOnwG-w3CQQffk',
    appId: '1:134903753517:web:9cade2b1f7d4ff54c381a4',
    messagingSenderId: '134903753517',
    projectId: 'zid-manager-e61b2',
    authDomain: 'zid-manager-e61b2.firebaseapp.com',
    storageBucket: 'zid-manager-e61b2.firebasestorage.app',
    measurementId: 'G-16S1S8W2FT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjBCViOButNrUCZ0MTM8xfSlZF1Q6liFM',
    appId: '1:134903753517:android:57ccc7a63b23a163c381a4',
    messagingSenderId: '134903753517',
    projectId: 'zid-manager-e61b2',
    storageBucket: 'zid-manager-e61b2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBCMmlLrMDgTTfctH3joB-dv8pLHMLjtHQ',
    appId: '1:134903753517:ios:aa43a8ce6ea1e5ecc381a4',
    messagingSenderId: '134903753517',
    projectId: 'zid-manager-e61b2',
    storageBucket: 'zid-manager-e61b2.firebasestorage.app',
    iosBundleId: 'com.example.zedStoreMangent',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBCMmlLrMDgTTfctH3joB-dv8pLHMLjtHQ',
    appId: '1:134903753517:ios:aa43a8ce6ea1e5ecc381a4',
    messagingSenderId: '134903753517',
    projectId: 'zid-manager-e61b2',
    storageBucket: 'zid-manager-e61b2.firebasestorage.app',
    iosBundleId: 'com.example.zedStoreMangent',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBhBIGcyVMcxfdG1ekLsYOnwG-w3CQQffk',
    appId: '1:134903753517:web:d497ce4f9c07312cc381a4',
    messagingSenderId: '134903753517',
    projectId: 'zid-manager-e61b2',
    authDomain: 'zid-manager-e61b2.firebaseapp.com',
    storageBucket: 'zid-manager-e61b2.firebasestorage.app',
    measurementId: 'G-1W6QHR7WGD',
  );
}
