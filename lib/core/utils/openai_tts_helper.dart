import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAiTtsHelper {
  final AudioPlayer _player = AudioPlayer();
  

  final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  bool isPlaying = false;
  Function? onStop;

  OpenAiTtsHelper({this.onStop}) {
    // Escuta quando o áudio termina para mudar o ícone
    _player.onPlayerComplete.listen((event) {
      isPlaying = false;
      if (onStop != null) onStop!();
    });
  }

  Future<void> speak(String text) async {
    // Se já estiver tocando, para.
    if (isPlaying) {
      await stop();
      return;
    }

    try {
      // 1. Configuração da API
      final url = Uri.parse('https://api.openai.com/v1/audio/speech');
      
      // Vozes disponíveis: 'onyx' (grave/masculina), 'shimmer' (feminina), 'alloy' (neutra)
      // 'onyx' fica muito bom para leitura bíblica.
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "tts-1", // tts-1 é rápido, tts-1-hd é alta definição
          "input": text,
          "voice": "onyx" 
        }),
      );

      if (response.statusCode == 200) {
        // 2. Salva o arquivo MP3 temporariamente no celular
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/verse_audio.mp3');
        await file.writeAsBytes(response.bodyBytes);

        // 3. Toca o arquivo
        await _player.play(DeviceFileSource(file.path));
        isPlaying = true;
      } else {
        print("Erro OpenAI (${response.statusCode}): ${response.body}");
        isPlaying = false;
        if (onStop != null) onStop!();
      }
    } catch (e) {
      print("Erro ao tocar áudio: $e");
      isPlaying = false;
      if (onStop != null) onStop!();
    }
  }

  Future<void> stop() async {
    await _player.stop();
    isPlaying = false;
    if (onStop != null) onStop!();
  }
}