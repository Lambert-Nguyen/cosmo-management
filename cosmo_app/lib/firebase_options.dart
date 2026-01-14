// File generated based on Firebase configuration for Cosmo Management
// Project: cosmomanagement-ed731
//
// To regenerate this file, run:
//   flutterfire configure
//
// Learn more about Firebase configuration at:
// https://firebase.google.com/docs/flutter/setup

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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

  // Values from google-services.json and GoogleService-Info.plist
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaLEWm5sAqVsBqbvpon9sHY4oeHRg1ar0',
    appId: '1:973172271140:android:bc3f219472e69c20dfd0b1',
    messagingSenderId: '973172271140',
    projectId: 'cosmomanagement-ed731',
    storageBucket: 'cosmomanagement-ed731.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAgNgna2h8Tm7ey6oBHKQIcldLz8a17FqQ',
    appId: '1:973172271140:ios:64e012cd0740ce8adfd0b1',
    messagingSenderId: '973172271140',
    projectId: 'cosmomanagement-ed731',
    storageBucket: 'cosmomanagement-ed731.firebasestorage.app',
    iosBundleId: 'com.cosmomgmt.app',
  );

  // Web configuration
  // To get the web appId:
  // 1. Go to Firebase Console > Project Settings > Your apps
  // 2. Click "Add app" > Web icon
  // 3. Register app with nickname "Cosmo Web"
  // 4. Copy the appId value (format: 1:973172271140:web:xxxxxxxxxx)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAaLEWm5sAqVsBqbvpon9sHY4oeHRg1ar0',
    appId: '1:973172271140:web:placeholder_configure_in_firebase',
    messagingSenderId: '973172271140',
    projectId: 'cosmomanagement-ed731',
    storageBucket: 'cosmomanagement-ed731.firebasestorage.app',
    authDomain: 'cosmomanagement-ed731.firebaseapp.com',
  );

  // macOS configuration (same as iOS for most cases)
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAgNgna2h8Tm7ey6oBHKQIcldLz8a17FqQ',
    appId: '1:973172271140:ios:64e012cd0740ce8adfd0b1',
    messagingSenderId: '973172271140',
    projectId: 'cosmomanagement-ed731',
    storageBucket: 'cosmomanagement-ed731.firebasestorage.app',
    iosBundleId: 'com.cosmomgmt.app',
  );

  // Windows configuration (uses web app registration)
  // To get the windows appId:
  // 1. Go to Firebase Console > Project Settings > Your apps
  // 2. Click "Add app" > Web icon (Windows uses web SDK)
  // 3. Register app with nickname "Cosmo Windows"
  // 4. Copy the appId value (format: 1:973172271140:web:xxxxxxxxxx)
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAaLEWm5sAqVsBqbvpon9sHY4oeHRg1ar0',
    appId: '1:973172271140:web:placeholder_configure_in_firebase',
    messagingSenderId: '973172271140',
    projectId: 'cosmomanagement-ed731',
    storageBucket: 'cosmomanagement-ed731.firebasestorage.app',
    authDomain: 'cosmomanagement-ed731.firebaseapp.com',
  );
}
