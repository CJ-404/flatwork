import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flatwork/app/flatwork_app.dart';
import 'package:flatwork/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const ProviderScope(
      child: FlatWorkApp(),
    ),
  );
}
