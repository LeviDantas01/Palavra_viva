import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:versiculos_diarios/data/services/local_storage_service.dart';
import '../models/verse_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VerseRepository {
  final String _baseUrl = "https://www.abibliadigital.com.br/api";
  final LocalStorageService _localStorage = LocalStorageService();

  Map<String, String> _getHeaders() {
    final String token = dotenv.env['BIBLE_API_TOKEN'] ?? '';
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // 1. Aleatório
  Future<Verse> getNewRandomVerse(String version) async {
    final url = Uri.parse('$_baseUrl/verses/$version/random');
    final response = await http.get(url, headers: _getHeaders());

    if (response.statusCode == 200) {
      return Verse.fromJson(jsonDecode(response.body), version);
    } else {
      throw Exception('Falha ao carregar versículo: ${response.statusCode}');
    }
  }

  // 2. Diário
  Future<Verse> getDailyVerse(String version) async {
    final now = DateTime.now();
    final String todayKey = "${now.year}-${now.month}-${now.day}";

    final cachedData = await _localStorage.getDailyVerseData();

    if (cachedData != null && cachedData['date'] == todayKey) {
      final String textKey = 'text_$version';

      if (cachedData.containsKey(textKey) && cachedData[textKey] != null) {
        return Verse(
          text: cachedData[textKey],
          bookName: cachedData['book_name'],
          bookAbbrev: cachedData['book_abbrev'],
          chapter: cachedData['chapter'],
          number: cachedData['number'],
          version: version,
        );
      }

      final translatedVerse = await getTranslation(
        version,
        cachedData['book_abbrev'],
        cachedData['chapter'],
        cachedData['number'],
      );

      if (translatedVerse != null) {
        await _localStorage.updateDailyVerseTranslation(
          version,
          translatedVerse.text,
        );
        return translatedVerse;
      }
    }

    try {
      final newVerse = await getNewRandomVerse(version);

      await _localStorage.saveDailyVerseData(todayKey, newVerse);

      return newVerse;
    } catch (e) {
      if (cachedData != null) {
        return Verse(
          text:
              cachedData['text_$version'] ??
              cachedData.values.firstWhere((v) => v is String && v.length > 10),
          bookName: cachedData['book_name'],
          bookAbbrev: cachedData['book_abbrev'],
          chapter: cachedData['chapter'],
          number: cachedData['number'],
          version: version,
        );
      }
      rethrow;
    }
  }

  // 3. Tradução
  Future<Verse?> getTranslation(
    String version,
    String book,
    int chapter,
    int number,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl/verses/$version/$book/$chapter/$number');
      final response = await http.get(url, headers: _getHeaders());

      if (response.statusCode == 200) {
        return Verse.fromJson(jsonDecode(response.body), version);
      }
    } catch (e) {
      print("Erro tradução: $e");
    }
    return null;
  }

  // 4. Capítulo Inteiro
  Future<List<Verse>> getChapter(
    String version,
    String bookAbbrev,
    int chapter,
  ) async {
    final url = Uri.parse('$_baseUrl/verses/$version/$bookAbbrev/$chapter');

    print("Tentando acessar: $url");

    final response = await http.get(url, headers: _getHeaders());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['verses'] == null) {
        throw Exception('Formato inválido recebido da API');
      }

      final List versesData = data['verses'];
      final String nameOfBook = data['book']['name'];

      return versesData
          .map(
            (v) => Verse(
              text: v['text'],
              bookName: nameOfBook,
              bookAbbrev: bookAbbrev,
              chapter: chapter,
              number: v['number'],
              version: version,
            ),
          )
          .toList();
    } else {
      print("ERRO API: ${response.statusCode} - ${response.body}");
      throw Exception('Falha ao carregar capítulo');
    }
  }
}
