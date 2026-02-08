import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/verse_model.dart';

class LocalStorageService {
  static const String _keyDailyVerse = 'daily_verse_data';

  // 1. Salva o versículo do dia pela primeira vez
  Future<void> saveDailyVerseData(String dateKey, Verse verse) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Cria o mapa de dados para salvar
    final Map<String, dynamic> data = {
      'date': dateKey,
      'book_name': verse.bookName,
      'book_abbrev': verse.bookAbbrev,
      'chapter': verse.chapter,
      'number': verse.number,
      // Salva o texto com a chave da versão (ex: 'text_nvi')
      'text_${verse.version}': verse.text, 
    };
    
    // Transforma em texto (JSON) e salva
    await prefs.setString(_keyDailyVerse, jsonEncode(data));
  }

  // 2. Recupera os dados salvos
  Future<Map<String, dynamic>?> getDailyVerseData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? source = prefs.getString(_keyDailyVerse);
    
    if (source == null) return null; // Não tem nada salvo
    
    try {
      return jsonDecode(source) as Map<String, dynamic>;
    } catch (e) {
      return null; // Se o JSON estiver corrompido
    }
  }

  // 3. Atualiza apenas a tradução (ex: Adiciona o texto em Inglês no cache existente)
  Future<void> updateDailyVerseTranslation(String version, String text) async {
    final prefs = await SharedPreferences.getInstance();
    final String? source = prefs.getString(_keyDailyVerse);
    
    if (source != null) {
      Map<String, dynamic> data = jsonDecode(source);
      
      // Adiciona a nova chave (ex: 'text_kjv')
      data['text_$version'] = text; 
      
      // Salva de volta
      await prefs.setString(_keyDailyVerse, jsonEncode(data));
    }
  }
}