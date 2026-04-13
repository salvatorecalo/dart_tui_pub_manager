import '../../utils/index.dart';
import 'package:dart_console/dart_console.dart';
import 'package:mason_logger/mason_logger.dart';
import '../uninstall_packages/uninstall_packages.dart';
import 'dart:io';

Future<void> manageInstalledPackages(Console console, Logger logger) async {
  List<String> installedPackages = getAllInstalledPackages(logger, Directory.current);
  if (installedPackages.isEmpty) {
    console.writeLine("\nYou don't have any installed packages.");
    console.readKey();
    return;
  }
  int selectedIndex = 0;

  console.writeLine("\n[↑/↓] Go up and down | [Enter] Uninstall | [Esc] Go back to menu");
  while (true) {
    installedPackages = getAllInstalledPackages(logger, Directory.current);
    console.clearScreen();
    console.writeLine("All your installed packages");
    console.writeLine("Press X to uninstall, [ESC] to go back to main menu");
    console.writeLine("---------------------------");
    for (int i = 0; i < installedPackages.length; i++) {
      if (i == selectedIndex) {
        console.setForegroundColor(ConsoleColor.red);
        console.writeLine("> [REM] ${installedPackages[i]}".padRight(console.windowWidth));
        console.resetColorAttributes();
      } else {
        console.writeLine("  ${installedPackages[i]}");
      }
    }
    final Key key = console.readKey();
    if (key.controlChar == ControlCharacter.arrowDown) {
        if (selectedIndex < installedPackages.length - 1) selectedIndex++;
    } else if (key.controlChar == ControlCharacter.arrowUp) {
      if (selectedIndex >= 0) selectedIndex--;
    } else if (key.char.toLowerCase() == 'x'){
      await uninstallPackages(logger, console, installedPackages[selectedIndex]);
    } else if (key.controlChar == ControlCharacter.escape) {
      return;
    }
  }
}