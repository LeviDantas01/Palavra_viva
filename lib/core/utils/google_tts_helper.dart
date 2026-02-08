import 'package:audioplayers/audioplayers.dart';

class GoogleTtsHelper {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;
  Function? onStop;

  GoogleTtsHelper({this.onStop}) {
    _player.onPlayerComplete.listen((event) {
      isPlaying = false;
      if (onStop != null) onStop!();
    });
  }

  Future<void> speak(String text, String version) async {
    if (isPlaying) {
      await stop();
      return;
    }

    try {
      // Mapeia sua versão para o código do Google Translate
      // pt = Português, en = Inglês
      String lang = version == 'nvi' ? 'pt' : 'en';

      // Essa é a URL "mágica" pública do Google Translate
      // client=tw-ob é o segredo para funcionar sem API Key
      final String url = "https://translate.google.com/translate_tts?ie=UTF-8&q=${Uri.encodeComponent(text)}&tl=$lang&client=tw-ob";

      // Toca direto da URL (streaming)
      await _player.play(UrlSource(url));
      isPlaying = true;
    } catch (e) {
      print("Erro ao tocar áudio: $e");
      // Se der erro (internet falhou), avisa para parar o ícone
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