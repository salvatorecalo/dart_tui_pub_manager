import 'package:dart_console/dart_console.dart';
import '../search_pubs/search_pubs.dart';
import '../install_packages/install_packages.dart';
import 'package:mason_logger/mason_logger.dart';
import '../uninstall_packages/uninstall_packages.dart';
import '../../utils/index.dart';
import 'dart:io';

Future<void> explorePackages(Console console,Logger logger, String query) async {
  int currentPage = 1;
  int selectedIndex = 0;

  while (true){
    console.clearScreen();
    final List<String> installedPackages = getAllInstalledPackages(logger, Directory.current);
    console.writeLine("🔍 Results for: '$query' | Page: $currentPage", TextAlignment.center);
    console.writeLine("--------------------------------------------------\n");

    final List<String> packages = await searchPubs(query, currentPage);

    if (packages.isEmpty){
      console.writeLine("❌ No packages found.");
      console.writeLine("Press a key to go back...");
      console.readKey();
      return;
    }

    for (int i = 0; i < packages.length; i++) {
      if (installedPackages.any((pkg) => pkg == packages[i])){
      if (i == selectedIndex) {
        console.setForegroundColor(ConsoleColor.yellow);
        console.writeLine("> [X] ${packages[i]}".padRight(console.windowWidth));
        console.resetColorAttributes();
      } else {
      console.writeLine("[X] ${packages[i]}");
      }
      } else {
      if (i == selectedIndex) {
        console.setForegroundColor(ConsoleColor.yellow);
        console.writeLine("> ${packages[i]}".padRight(console.windowWidth));
        console.resetColorAttributes();
      } else {
          console.writeLine("  ${packages[i]}");
        }
      }
    }
    console.writeLine("\n[↑/↓] Go up and down | [Enter] Install | [→] Next page | [←] Previous page | [Esc] New search");
    final Key key = console.readKey();

    if (key.controlChar == ControlCharacter.arrowDown) {
      if (selectedIndex < packages.length - 1) selectedIndex++;
    } else if (key.controlChar == ControlCharacter.arrowUp) {
      if (selectedIndex > 0) selectedIndex--;
    } else if (key.controlChar == ControlCharacter.arrowRight) {
      currentPage++;
      selectedIndex = 0;
    } else if (key.controlChar == ControlCharacter.arrowLeft) {
      if (currentPage > 1) currentPage--;
      selectedIndex = 0;
    } else if (key.controlChar == ControlCharacter.escape) {
      return;
    } else if (key.controlChar == ControlCharacter.enter) {
        await installPackages(logger, console, packages[selectedIndex]);
    } else if (key.char.toLowerCase() == 'x'){
        await uninstallPackages(logger, console, packages[selectedIndex]);
    }
  }
}