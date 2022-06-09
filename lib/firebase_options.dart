// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBUnnSSXRr43Y2RCLd37pahmueMll5HO_0',
    appId: '1:597694034365:web:4d72b5ead3fbb2e633e2d4',
    messagingSenderId: '597694034365',
    projectId: 'hi-quotes-13d85',
    authDomain: 'hi-quotes-13d85.firebaseapp.com',
    storageBucket: 'hi-quotes-13d85.appspot.com',
    measurementId: 'G-0SKCGX7SHC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgjA7KAcVQbG-0-jU-w_MsGt-d7FTmBmg',
    appId: '1:597694034365:android:4bf36556c6fc1b9c33e2d4',
    messagingSenderId: '597694034365',
    projectId: 'hi-quotes-13d85',
    storageBucket: 'hi-quotes-13d85.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDiIrvSyZ9xD5xb24vxWBARXJzuONpTvXs',
    appId: '1:597694034365:ios:2f5d4cddd3c6499333e2d4',
    messagingSenderId: '597694034365',
    projectId: 'hi-quotes-13d85',
    storageBucket: 'hi-quotes-13d85.appspot.com',
    iosClientId: '597694034365-nk82ct5stbjjm1ufmaq8u1req6dek9es.apps.googleusercontent.com',
    iosBundleId: 'com.hiquote-app',
  );
}
