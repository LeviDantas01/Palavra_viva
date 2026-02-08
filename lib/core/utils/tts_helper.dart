import 'package:flutter_tts/flutter_tts.dart';

class TtsHelper {
  final FlutterTts _flutterTts = FlutterTts();
  bool isPlaying = false;
  Function? onStop;

  TtsHelper({this.onStop}) {
    _initTts();
  }

  void _initTts() async {
    // Configuração base
    await _flutterTts.setSpeechRate(0.5); // 0.5 é uma velocidade boa para ambos
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
    
    // Garante que o app saiba quando a fala terminou
    await _flutterTts.awaitSpeakCompletion(true);

    _flutterTts.setCompletionHandler(() {
      isPlaying = false;
      if (onStop != null) onStop!();
    });
  }

  // Agora aceitamos a VERSÃO novamente ('nvi' ou 'kjv')
  Future<void> speak(String text, String version) async {
    if (isPlaying) {
      await stop();
      return;
    }

    // Lógica de seleção de idioma
    String language = version == 'nvi' ? 'pt-BR' : 'en-US';

    try {
      await _flutterTts.setLanguage(language);
      
      // Tenta usar o motor do Google para garantir a melhor qualidade instalada
      await _flutterTts.setEngine("com.google.android.tts");
      
      isPlaying = true;
      await _flutterTts.speak(text);
    } catch (e) {
      print("Erro TTS: $e");
      isPlaying = false;
      if (onStop != null) onStop!();
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    isPlaying = false;
    if (onStop != null) onStop!();
  }
}