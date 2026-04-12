import 'dart:io';
import 'package:dart_console/dart_console.dart';
import 'package:mason_logger/mason_logger.dart';

Future<void> installPackages(Console console, String packageName) async{
    final Logger logger = Logger();
    final progress = logger.progress("Installing $packageName");
    final result = await Process.run("dart", ["pub", "add", packageName]);
    if (result.exitCode == 0){
      progress.complete('$packageName installato con successo!');
    } else {
      progress.fail('Errore durante l\'installazione di $packageName');
      logger.err('${result.stderr}');
    }
    console.writeLine('\nPremi un tasto qualsiasi per tornare alla lista...');
    console.readKey();
}