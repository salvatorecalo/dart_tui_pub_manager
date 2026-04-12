import 'dart:io';
import 'package:mason_logger/mason_logger.dart';
import 'package:yaml/yaml.dart';

List<String> getAllInstalledPackages(Logger logger){
  final File file = File('pubspec.yaml');
  if (!file.existsSync()) {
    logger.err("File pubspec.yaml not found");
    return [];
  }

  final String yamlString = file.readAsStringSync();
  final yaml = loadYaml(yamlString);
  final Map? dependencies = yaml['dependencies'];
  if (dependencies == null) return [];

  return dependencies.keys
      .where((k) => k != 'flutter')
      .cast<String>()
      .toList();
}