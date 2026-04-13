import 'dart:io';
import 'package:dart_console/dart_console.dart';
import 'package:mason_logger/mason_logger.dart';

Future<void> installPackages(Logger logger, Console console, String packageName, {String? workingDirectory}) async{
    final progress = logger.progress("Installing $packageName");
    final result = await Process.run("dart", ["pub", "add", packageName], workingDirectory: workingDirectory);
    if (result.exitCode == 0){
      progress.complete('$packageName successfully installed!');
    } else {
      progress.fail('Error during installation of $packageName');
      logger.err('${result.stderr}');
    }
    console.writeLine('\nPress any key to go back...');
    console.readKey();
}