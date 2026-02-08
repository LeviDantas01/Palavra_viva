import 'package:flutter/material.dart';
import '../../data/repositories/verse_repository.dart';
import '../../data/models/verse_model.dart';
import '../../core/utils/openai_tts_helper.dart';

// Importamos os widgets novos
import '../widgets/verse_display_card.dart';
import '../widgets/audio_button.dart';
import '../widgets/language_toggle.dart';
import '../widgets/error_retry_widget.dart';
import '../widgets/next_button.dart';

class VerseScreen extends StatefulWidget {
  final bool isDaily;

  const VerseScreen({super.key, required this.isDaily});

  @override
  State<VerseScreen> createState() => _VerseScreenState();
}

class _VerseScreenState extends State<VerseScreen> {
  final VerseRepository _repository = VerseRepository();
  late OpenAiTtsHelper _ttsHelper;

  Verse? _currentVerse;
  bool _isLoading = true;
  bool _isAudioLoading = false;
  String _currentLang = 'nvi';
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _ttsHelper = OpenAiTtsHelper(
      onStop: () {
        if (mounted) setState(() => _isSpeaking = false);
      },
    );
    _loadInitialVerse();
  }

  @override
  void dispose() {
    _ttsHelper.stop();
    super.dispose();
  }

  // --- LÓGICA (Mantida igual) ---
  
  Future<void> _loadInitialVerse() async {
    setState(() => _isLoading = true);

    if (_isSpeaking) {
      await _ttsHelper.stop();
      if (mounted) setState(() => _isSpeaking = false);
    }

    Verse? verse;
    try {
      if (widget.isDaily) {
        verse = await _repository.getDailyVerse(_currentLang);
      } else {
        verse = await _repository.getNewRandomVerse(_currentLang);
      }
    } catch (e) {
      print("Erro: $e");
    }

    if (mounted) {
      setState(() {
        _currentVerse = verse;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleLanguage() async {
    if (_isSpeaking) {
      await _ttsHelper.stop();
      setState(() => _isSpeaking = false);
    }

    setState(() {
      _currentLang = _currentLang == 'nvi' ? 'kjv' : 'nvi';
      _isLoading = true;
    });

    Verse? newVerse;
    if (_currentVerse != null) {
      newVerse = await _repository.getTranslation(
        _currentLang, 
        _currentVerse!.bookAbbrev, 
        _currentVerse!.chapter, 
        _currentVerse!.number
      );
    } 
    
    if (newVerse == null) {
       if (widget.isDaily) {
         newVerse = await _repository.getDailyVerse(_currentLang);
       } else {
         newVerse = await _repository.getNewRandomVerse(_currentLang);
       }
    }

    if (mounted) {
      setState(() {
        _currentVerse = newVerse;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleAudio() async {
    if (_currentVerse == null || _isAudioLoading) return;

   if (_isSpeaking) {
      await _ttsHelper.stop();
      setState(() => _isSpeaking = false);
    } else {
      setState(() => _isAudioLoading = true);
      try {
        await _ttsHelper.speak(_currentVerse!.text);
        if (mounted) {
          setState(() {
            _isAudioLoading = false;
            _isSpeaking = true;
          });
        }
      } catch (e) {
        if (mounted) setState(() => _isAudioLoading = false);
      }
    }
  }

  // --- UI (Agora muito mais limpa) ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isDaily ? "Versículo do Dia" : "Aleatório",
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.black12)
                : _currentVerse != null
                    ? VerseDisplayCard(verse: _currentVerse!)
                    : ErrorRetryWidget(onRetry: _loadInitialVerse), // Widget Novo
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LanguageToggle(
                  currentLang: _currentLang,
                  isDisabled: _isLoading,
                  onTap: _toggleLanguage,
                ),
                
                const SizedBox(width: 20),
                
                // Widget Novo de Áudio
                AudioButton(
                  isSpeaking: _isSpeaking,
                  isLoading: _isAudioLoading,
                  onTap: _toggleAudio,
                ),

                if (!widget.isDaily) ...[
                  const SizedBox(width: 20),

                  NextButton(
                    isLoading: _isLoading,
                    onTap: _loadInitialVerse, 
                  ),
              ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}