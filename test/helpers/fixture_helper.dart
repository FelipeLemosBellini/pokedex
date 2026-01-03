import 'dart:io';

String fixture(String feature, String name) =>
    File('test/features/$feature/fixtures/$name.json').readAsStringSync();
