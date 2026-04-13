import 'dart:io';
import 'package:dart_console/dart_console.dart';
import 'plugins/index.dart';
import 'package:mason_logger/mason_logger.dart';

void main() async {
  final Console console = Console();
  final Logger logger = Logger();
  String? query = '';

  while (true){
    console.clearScreen();
    console.writeLine("=== 📦 DART PUB MANAGER ===", TextAlignment.center);
    console.writeLine("---------------------------", TextAlignment.center);
    console.writeLine("\nWhat do you want to do?");
    console.writeLine("1. 🔍 Search and install new packages");
    console.writeLine("2. 🗑️  Manage / Remove installed packages");
    console.writeLine("q. ❌ Quit");
    console.write("\nChoice: ");
    final input = stdin.readLineSync()?.toLowerCase();
    if (input == 'q') break;
    if (input == '1') {
      console.write("Package name (or 'q' to exit): ");
      query = stdin.readLineSync();
      while (query!.isEmpty) {
        console.writeErrorLine("query cannot be empty. Rewrite a good package name (or q to exit): ");
        query = stdin.readLineSync();
      }
      if (query.toLowerCase() == 'q') break;
      if (query.isEmpty) continue;
      await explorePackages(console,logger, query);
    } else {
      await manageInstalledPackages(console, logger);
    }
  }
}
