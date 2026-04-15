import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat_breed.dart';
import '../service/api_constants.dart';

class CatRepository {
  final http.Client _client = http.Client();

  Future<List<CatBreed>> getBreeds(int page, int limit) async {
    final response = await _client.get(Uri.parse('${ApiConstants.breedsEndpoint}?limit=$limit&page=$page'));
    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body)['data'] as List;
      return jsonList.map((e) => CatBreed.fromJson(e)).toList();
    }
    throw Exception('Error al descargar razas de gatos');
  }

  Future<String> getRandomFact() async {
    final response = await _client.get(Uri.parse(ApiConstants.factEndpoint));
    if (response.statusCode == 200) {
      return json.decode(response.body)['fact'];
    }
    throw Exception('Error al obtener dato curioso');
  }
}
