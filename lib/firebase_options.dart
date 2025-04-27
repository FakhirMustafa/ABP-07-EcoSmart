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
    apiKey: 'AIzaSyD8wEpcWLmSzHvkQyIZHYmzpURGICslPos',
    appId: '1:111262480834:web:f0403a1f8d6b0349927e5b',
    messagingSenderId: '111262480834',
    projectId: 'tubes-abp-07',
    authDomain: 'tubes-abp-07.firebaseapp.com',
    storageBucket: 'tubes-abp-07.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_jsvp6HWINp1NIFdZhaI0Iwo0ZX_9TKw',
    appId: '1:111262480834:android:a9df27c71da25fda927e5b',
    messagingSenderId: '111262480834',
    projectId: 'tubes-abp-07',
    storageBucket: 'tubes-abp-07.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeRm6xRk2WXOOWzosW-L9y9Yi-cD8RadE',
    appId: '1:111262480834:ios:84f3b3afdc4f930e927e5b',
    messagingSenderId: '111262480834',
    projectId: 'tubes-abp-07',
    storageBucket: 'tubes-abp-07.firebasestorage.app',
    iosBundleId: 'com.example.flutterApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDeRm6xRk2WXOOWzosW-L9y9Yi-cD8RadE',
    appId: '1:111262480834:ios:84f3b3afdc4f930e927e5b',
    messagingSenderId: '111262480834',
    projectId: 'tubes-abp-07',
    storageBucket: 'tubes-abp-07.firebasestorage.app',
    iosBundleId: 'com.example.flutterApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD8wEpcWLmSzHvkQyIZHYmzpURGICslPos',
    appId: '1:111262480834:web:7fbd798c7b3f5eef927e5b',
    messagingSenderId: '111262480834',
    projectId: 'tubes-abp-07',
    authDomain: 'tubes-abp-07.firebaseapp.com',
    storageBucket: 'tubes-abp-07.firebasestorage.app',
  );

}