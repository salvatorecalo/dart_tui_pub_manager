import 'package:dart_console/dart_console.dart';
import '../search_pubs/search_pubs.dart';
import '../install_packages/install_packages.dart';

Future<void> explorePackages(Console console, String query) async {
  int currentPage = 1;
  int selectedIndex = 0;

  while (true){
    console.clearScreen();
    console.writeLine("🔍 Results for: '$query' | Page: $currentPage", TextAlignment.center);
    console.writeLine("--------------------------------------------------\n");

    final List<String> packages = await searchPubs(query, currentPage);

    if (packages.isEmpty){
      console.writeLine("❌ Nessun pacchetto trovato.");
      console.writeLine("Premi un tasto per tornare alla ricerca...");
      console.readKey();
      return;
    }

    for (int i = 0; i < packages.length; i++) {
      if (i == selectedIndex) {
        console.setForegroundColor(ConsoleColor.yellow);
        console.writeLine("> ${packages[i]}".padRight(console.windowWidth));
        console.resetColorAttributes();
      } else {
        console.writeLine("  ${packages[i]}");
      }
    }
    console.writeLine("\n[↑/↓] Naviga | [Enter] Installa | [→] Pagina Succ | [←] Pagina Prec | [Esc] Nuova Ricerca");
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
      await installPackages(console, packages[selectedIndex]);
    }
  }
}