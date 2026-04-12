import 'package:mason_logger/mason_logger.dart';
import 'dart:io';
import 'package:dart_console/dart_console.dart';
import '../../utils/index.dart';

Future<void> uninstallPackages(Logger logger, Console console, String packageName) async {
  final List<String> installedPackages = getAllInstalledPackages(logger);
  if (!installedPackages.any((pkg) => pkg == packageName)){
    logger.err("You don't have $packageName installed");
    return;
  };
  final progress = logger.progress("Uninstalling $packageName...");
  final result = await Process.run("dart", ["pub","remove", packageName]);
  if (result.exitCode == 0){
    progress.complete("$packageName uninstalled successfully!");
  } else {
    progress.fail("Error during uninstallation of $packageName");
    logger.err("${result.stderr}");
  }
  console.writeLine('\nPress any key to go back...');
  console.readKey();
}