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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDeUTpplWrMYkeG8FxySTv2N4oRO9oWTj0',
    appId: '1:321620852969:android:4aa4e264c082a32bd3b078',
    messagingSenderId: '321620852969',
    projectId: 'climbingapp-41f44',
    databaseURL: 'https://climbingapp-41f44-default-rtdb.firebaseio.com',
    storageBucket: 'climbingapp-41f44.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0ra87_IZyocSWOmQHnW4XG00N0MQe7_A',
    appId: '1:321620852969:ios:30390fa95c5a2df4d3b078',
    messagingSenderId: '321620852969',
    projectId: 'climbingapp-41f44',
    databaseURL: 'https://climbingapp-41f44-default-rtdb.firebaseio.com',
    storageBucket: 'climbingapp-41f44.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );
}
