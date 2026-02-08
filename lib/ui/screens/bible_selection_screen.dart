import 'package:flutter/material.dart';
import 'dart:math'; // Necessário para gerar cores aleatórias
import '../../data/local/bible_data.dart';
import 'chapter_screen.dart';

class BibleSelectionScreen extends StatelessWidget {
  const BibleSelectionScreen({super.key});

  // Função auxiliar para gerar cores vibrantes e aleatórias
  Color _getRandomColor() {
    // Lista de cores bonitas para escolher
    final List<Color> colors = [
      Colors.blueAccent, Colors.redAccent, Colors.greenAccent, Colors.orangeAccent,
      Colors.purpleAccent, Colors.tealAccent, Colors.pinkAccent, Colors.amberAccent,
      Colors.cyanAccent, Colors.indigoAccent, Colors.limeAccent, Colors.deepPurpleAccent
    ];
    // Sorteia uma cor da lista e aplica uma leve transparência
    return colors[Random().nextInt(colors.length)].withOpacity(0.9);
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Bíblia Sagrada", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      // MUDANÇA PRINCIPAL: ListView virou GridView
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Mostra 2 livros por linha
          crossAxisSpacing: 15, // Espaço horizontal entre eles
          mainAxisSpacing: 15, // Espaço vertical entre eles
          childAspectRatio: 1.3, // Proporção (largura/altura) para ficar retangular
        ),
        itemCount: BibleData.books.length,
        itemBuilder: (context, index) {
          String bookName = BibleData.books.keys.elementAt(index);
          int totalChapters = BibleData.books.values.elementAt(index);
          
          // Gera uma cor única para este cartão
          Color cardColor = _getRandomColor();

          return GestureDetector(
            onTap: () {
              // Abre o modal de capítulos (igual antes)
              _showChapterSelection(context, bookName, totalChapters);
            },
            child: Container(
              decoration: BoxDecoration(
                color: cardColor, // Usa a cor sorteada
                borderRadius: BorderRadius.circular(15), // Cantos arredondados
                boxShadow: [
                  BoxShadow(
                    color: cardColor.withOpacity(0.4), // Sombra da mesma cor
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    bookName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white, // Texto branco para contraste
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // Sombra no texto para leitura fácil
                      shadows: [Shadow(blurRadius: 2, color: Colors.black26, offset: Offset(1, 1))]
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // O modal de seleção de capítulos continua exatamente o mesmo
  void _showChapterSelection(BuildContext context, String bookName, int totalChapters) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 400,
          child: Column(
            children: [
              Text("Escolha o Capítulo de $bookName", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: totalChapters,
                  itemBuilder: (context, index) {
                    final chapterNum = index + 1;
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChapterScreen(
                              bookName: bookName,
                              bookAbbrev: BibleData.getAbbreviation(bookName),
                              chapter: chapterNum,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "$chapterNum",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}