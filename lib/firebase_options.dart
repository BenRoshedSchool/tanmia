// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8ZGI9Pk37JIBzIYk1tt9vqaAAHC0qCgs',
    appId: '1:759906274899:android:84ee62f3d11d2f524980a6',
    messagingSenderId: '759906274899',
    projectId: 'zawaida-app',
    databaseURL: 'https://zawaida-app-default-rtdb.firebaseio.com',
    storageBucket: 'zawaida-app.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA-TjNBuhVQgPWreVCgn2qiArgCkl_cenI',
    appId: '1:759906274899:web:92ecf8dd0163a3e64980a6',
    messagingSenderId: '759906274899',
    projectId: 'zawaida-app',
    authDomain: 'zawaida-app.firebaseapp.com',
    databaseURL: 'https://zawaida-app-default-rtdb.firebaseio.com',
    storageBucket: 'zawaida-app.firebasestorage.app',
    measurementId: 'G-66PKDB6SYL',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA-TjNBuhVQgPWreVCgn2qiArgCkl_cenI',
    appId: '1:759906274899:web:b096a53fb2fb29c94980a6',
    messagingSenderId: '759906274899',
    projectId: 'zawaida-app',
    authDomain: 'zawaida-app.firebaseapp.com',
    databaseURL: 'https://zawaida-app-default-rtdb.firebaseio.com',
    storageBucket: 'zawaida-app.firebasestorage.app',
    measurementId: 'G-JTDC1J9NXQ',
  );

}