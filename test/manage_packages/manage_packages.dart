import 'package:test/test.dart';
import 'dart:io';
import 'package:dart_console/dart_console.dart';
import 'package:mason_logger/mason_logger.dart';
import '../../bin/utils/index.dart';
import '../../bin/plugins/index.dart';

void main() {
  late Directory tempDir;
  final Logger logger = Logger();
  final Console console = Console();

  setUp((){
    tempDir = Directory.systemTemp.createTempSync('manage_pub_test_');
    File('${tempDir.path}/pubspec.yaml').writeAsStringSync(
        '''
          name: test_project
          environment:
            sdk: ^3.10.0
          dependencies:
            http: ^1.6.0
          '''
    );
  });

  tearDown(() {
    if (tempDir.existsSync()){
      tempDir.deleteSync(recursive: true);
    }
  });

  group('Manage packages', (){
    test('getAllInstalledPackages should find http', (){
      final List<String> packages = getAllInstalledPackages(logger, tempDir);
      // We installed http above so it should contains it
      expect(packages, contains('http'));
      // We excluded flutter and sdk package so it should not contain it
      expect(packages, isNot(contains('flutter')));
    });

    test('Install package should install package from pub.dev', () async {
      await installPackages(logger, console, 'http');
      final List<String> packages = getAllInstalledPackages(logger, tempDir);
      expect(packages, contains('http'));
    });

    test('uninstall packages should remove packages from pubspec.yaml', () async {
      await installPackages(logger, console, 'http', workingDirectory: tempDir.path);
      await uninstallPackages(logger, console, 'http', workingDirectory: tempDir);
      final List<String> packages = getAllInstalledPackages(logger, tempDir);
      expect(packages, isNot(contains('http')));
    });
  });
}