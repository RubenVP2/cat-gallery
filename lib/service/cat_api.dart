import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../model/Cat.dart';

class CatApi {

  final String apiUrl = 'https://api.thecatapi.com/v1/images/search';

  Future<Cat> fetchCatImage() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return Cat.fromJson(jsonDecode(response.body)[0]);
    } else {
      throw Exception('Erreur lors de l\'appel api');
    }
  }

  fetchBytes(String url) async {
    return await Dio().get(
      url,
      options: Options(responseType: ResponseType.bytes)
    );
  }

}