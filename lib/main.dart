import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex/app_module.dart';
import 'package:pokedex/app_widget.dart';
import 'package:pokedex/core/env/env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  await Firebase.initializeApp();
  await Env.start();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ModularApp(
      module: AppModule(sharedPreferences: sharedPreferences),
      child: const AppWidget(),
    ),
  );

  FlutterNativeSplash.remove();
}
