import 'dart:io';
import 'package:mason_logger/mason_logger.dart';
import 'package:yaml/yaml.dart';

List<String> getAllInstalledPackages(Logger logger){
  final Directory directory = Directory.current;
  final File file = File('${directory.path}/pubspec.yaml');
  if (!file.existsSync()) {
    logger.err("Errore: pubspec.yaml not found in ${directory.path}. Please run this tool in the root of your project!");
    return [];
  }
  try {
    final String yamlString = file.readAsStringSync();
    final dynamic yaml = loadYaml(yamlString);
    if (yaml == null || yaml['dependencies'] == null) return [];
    final dynamic deps = yaml['dependencies'];
    final List<String> packageList = [];

    if (deps is Map) {
      for (var entry in deps.entries) {
        final String name = entry.key.toString();
        if (name != 'flutter' && name != 'sdk') {
          packageList.add(name);
        }
      }
    }
    return packageList;
  } catch (e) {
    logger.err("Error during parsing of yaml file: $e");
    return [];
  }
}