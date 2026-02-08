import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/verse_model.dart';
import '../../core/constants/api_constants.dart';

class ApiService {
  
  // Helper para criar o cabeçalho com autenticação
  Map<String, String> get _headers => {
    'Authorization': 'Bearer ${ApiConstants.token}',
    'Content-Type': 'application/json',
  };

  // 1. Busca Versículo Aleatório
  Future<Verse?> getRandomVerse(String version) async {
    final client = http.Client();
    final url = Uri.parse('${ApiConstants.baseUrl}/verses/$version/random');

    try {
      // Note o parâmetro 'headers' aqui
      final response = await client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Verse.fromJson(jsonResponse, version);
      } else {
        print('Erro na API (${response.statusCode}): ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return null;
    } finally {
      client.close();
    }
  }

  // 2. Busca Versículo Específico (Para a tradução funcionar)
  Future<Verse?> getSpecificVerse(String version, String bookAbbrev, int chapter, int number) async {
    final client = http.Client();
    final url = Uri.parse('${ApiConstants.baseUrl}/verses/$version/$bookAbbrev/$chapter/$number');

    try {
      // Note o parâmetro 'headers' aqui também
      final response = await client.get(url, headers: _headers);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Verse.fromJson(jsonResponse, version);
      }
      return null;
    } catch (e) {
      print('Erro: $e');
      return null;
    } finally {
      client.close();
    }
  }
}