import 'dart:io';
import 'package:dart_console/dart_console.dart';
import 'plugins/index.dart';

void main() async {
  final Console console = Console();
  String? query = '';

  while (true){
    console.clearScreen();
    console.writeLine("=== 📦 dart pub finder ===", TextAlignment.center);
    console.write("Package name (or 'q' to exit): ");
    query = stdin.readLineSync();
    if (query == null || query.toLowerCase() == 'q') break;
    if (query.isEmpty) continue;
    await explorePackages(console, query);
  }
}
