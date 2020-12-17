import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/initialize.dart';
import 'app/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  Initialize();
}
