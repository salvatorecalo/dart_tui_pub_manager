import '../../utils/index.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> searchPubs(String query, int currentPage) async {
  final url = Uri.parse("$PUB_QUERY_URL$query&page${currentPage.toString()}");
  final response = await http.get(url);
  if (response.statusCode == 200){
    final data = json.decode(response.body);
    final List packages = data['packages'] ?? [];
    return packages.map((currentPackage) => currentPackage['package'] as String).toList();
  } else {
    return [];
  }
}