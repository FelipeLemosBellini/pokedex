import 'package:flutter/services.dart';

abstract class AnalyticsLogEvents {
  static const String pokemonMostSelected = "pokemonMostSelected";
}

abstract class AnalyticsBridge {
  static const MethodChannel _channel = MethodChannel('com.pokedex');

  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? params,
  }) async {
    try {
      await _channel.invokeMethod('logEvent', {
        'name': name,
        'params': params ?? {},
      });
    } on PlatformException catch (e) {
      print('Erro ao logar evento: ${e.message}');
    }
  }
}
