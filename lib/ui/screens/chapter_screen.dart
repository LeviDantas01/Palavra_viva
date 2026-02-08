import 'package:flutter/material.dart';
import '../../data/repositories/verse_repository.dart';
import '../../data/models/verse_model.dart';
import '../../data/local/bible_data.dart';
import '../../core/utils/openai_tts_helper.dart';
import '../widgets/audio_button.dart';

class ChapterScreen extends StatefulWidget {
  final String bookName;
  final String bookAbbrev;
  final int chapter;

  const ChapterScreen({
    super.key,
    required this.bookName,
    required this.bookAbbrev,
    required this.chapter,
  });

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  final VerseRepository _repository = VerseRepository();
  final ScrollController _scrollController = ScrollController();
  
  // Helper de Áudio
  late OpenAiTtsHelper _ttsHelper;

  // Variáveis de Navegação (Mudam quando clica na seta)
  late String _currentBookName;
  late String _currentBookAbbrev;
  late int _currentChapter;

  List<Verse>? _verses;
  bool _isLoading = true;
  
  // Estados do Áudio
  bool _isSpeaking = false;
  bool _isAudioLoading = false;

  @override
  void initState() {
    super.initState();
    // Inicializa com o que veio da tela anterior
    _currentBookName = widget.bookName;
    _currentBookAbbrev = widget.bookAbbrev;
    _currentChapter = widget.chapter;

    _ttsHelper = OpenAiTtsHelper(
      onStop: () {
        if (mounted) setState(() => _isSpeaking = false);
      },
    );

    _loadChapter();
  }

  @override
  void dispose() {
    _ttsHelper.stop();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChapter() async {
    setState(() => _isLoading = true);
    
    // Se mudar de página, para o áudio anterior imediatamente
    if (_isSpeaking) {
      await _ttsHelper.stop();
      setState(() => _isSpeaking = false);
    }

    try {
      // FORÇAMOS 'nvi' (Português) AQUI
      final verses = await _repository.getChapter('nvi', _currentBookAbbrev, _currentChapter);
      
      if (mounted) {
        setState(() {
          _verses = verses;
          _isLoading = false;
        });
        // Volta o texto para o topo
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      }
    } catch (e) {
      print(e);
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- LÓGICA DE NAVEGAÇÃO (BOTÕES) ---

  void _goToNextChapter() {
    // Descobre quantos capítulos o livro atual tem
    int maxChapters = BibleData.books[_currentBookName] ?? 1000;

    if (_currentChapter < maxChapters) {
      // Se não é o último, avança +1
      setState(() {
        _currentChapter++;
      });
      _loadChapter();
    } else {
      // Se acabou o livro, pula para o próximo livro
      _goToNextBook();
    }
  }

  void _goToPrevChapter() {
    if (_currentChapter > 1) {
      setState(() {
        _currentChapter--;
      });
      _loadChapter();
    } else {
      // Aqui você pode implementar a lógica de voltar pro livro anterior se quiser
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Início do livro alcançado.")),
      );
    }
  }

  void _goToNextBook() {
    final keys = BibleData.books.keys.toList();
    final currentIndex = keys.indexOf(_currentBookName);

    // Se não for Apocalipse (último), avança
    if (currentIndex != -1 && currentIndex < keys.length - 1) {
      final nextBookName = keys[currentIndex + 1];
      
      setState(() {
        _currentBookName = nextBookName;
        _currentBookAbbrev = BibleData.getAbbreviation(nextBookName);
        _currentChapter = 1; // Sempre começa no capítulo 1 do novo livro
      });
      
      _loadChapter();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Iniciando $nextBookName")),
      );
    }
  }

  // --- LÓGICA DE ÁUDIO (SOMENTE PT) ---
  
  Future<void> _toggleAudio() async {
    if (_verses == null || _verses!.isEmpty || _isAudioLoading) return;

    if (_isSpeaking) {
      await _ttsHelper.stop();
      setState(() => _isSpeaking = false);
    } else {
      setState(() => _isAudioLoading = true);

      // Junta todo o texto do capítulo em uma string só
      String fullChapterText = _verses!.map((v) => v.text).join(" ");
      
      // Adiciona o título para a narração ficar completa
      String textToRead = "$_currentBookName, capítulo $_currentChapter. $fullChapterText";

      try {
        // A OpenAI detecta automaticamente que o texto é PT e lê em Português
        await _ttsHelper.speak(textToRead);
        
        if (mounted) {
          setState(() {
            _isAudioLoading = false;
            _isSpeaking = true;
          });
        }
      } catch (e) {
        if (mounted) setState(() => _isAudioLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text("Erro ao reproduzir áudio.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context), // Volta para a lista de livros
        ),
        title: Text(
          "$_currentBookName $_currentChapter",
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : _verses == null
              ? const Center(child: Text("Erro ao carregar."))
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 100), // Espaço no final
                  itemCount: _verses!.length,
                  itemBuilder: (context, index) {
                    final verse = _verses![index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black87, 
                            fontSize: 18, 
                            height: 1.6, // Espaçamento bom para leitura
                            fontFamily: 'Arial', // Fonte limpa
                          ),
                          children: [
                            TextSpan(
                              text: "${verse.number}  ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400], // Número discreto
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(text: verse.text),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      
      // BARRA INFERIOR DE NAVEGAÇÃO FIXA
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10, offset: const Offset(0, -5),
            )
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botão Anterior
              IconButton(
                onPressed: _isLoading || _currentChapter == 1 ? null : _goToPrevChapter,
                icon: Icon(
                  Icons.arrow_back_ios_new, 
                  color: _currentChapter > 1 ? Colors.black87 : Colors.grey[200]
                ),
              ),

              // Botão Áudio (Centro)
              AudioButton(
                isSpeaking: _isSpeaking,
                isLoading: _isAudioLoading,
                onTap: _toggleAudio,
              ),

              // Botão Próximo
              IconButton(
                onPressed: _isLoading ? null : _goToNextChapter,
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}