import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex/app_module.dart';
import 'package:pokedex/app_widget.dart';
import 'package:pokedex/core/env/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.start();
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
