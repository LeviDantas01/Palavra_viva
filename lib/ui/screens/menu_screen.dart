import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'verse_screen.dart';
import '../widgets/action_button.dart';
import 'bible_selection_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo e Título
              Icon(Icons.menu_book_rounded, size: 60, color: Colors.grey[800]),
              const SizedBox(height: 20),
              Text(
                "Palavra Viva",
                textAlign: TextAlign.center,
                style: GoogleFonts.merriweather(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 60),

              // Botão 1: Versículo do Dia (Usando o widget novo)
              ActionButton(
                text: "Versículo do Dia",
                icon: Icons.today_rounded,
                color: Colors.black87,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerseScreen(isDaily: true),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Botão 2: Aleatório (Usando o widget novo)
              ActionButton(
                text: "Versículo Aleatório",
                icon: Icons.shuffle_rounded,
                color: Colors.grey[700]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerseScreen(isDaily: false),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ActionButton(
                text: "Bíblia Completa",
                icon: Icons.menu_book_rounded, // Ícone de livro aberto
                color: Colors.blueGrey[700]!, // Uma cor diferente
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BibleSelectionScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Removemos a classe _MenuButton que ficava aqui embaixo