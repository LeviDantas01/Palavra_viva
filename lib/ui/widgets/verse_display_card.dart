import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/verse_model.dart';

class VerseDisplayCard extends StatelessWidget {
  final Verse verse;

  const VerseDisplayCard({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícone decorativo (aspas) para dar charme
          Icon(Icons.format_quote_rounded, size: 40, color: Colors.grey[300]),
          
          const SizedBox(height: 20),

          // O Texto do Versículo
          Text(
            verse.text,
            textAlign: TextAlign.center,
            style: GoogleFonts.merriweather(
              fontSize: 22,
              height: 1.5, // Espaçamento entre linhas melhora a leitura
              color: Colors.grey[850],
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 30),

          // A Referência (Livro Cap:Ver)
          Text(
            "${verse.bookName} ${verse.chapter}:${verse.number}",
            style: GoogleFonts.lato(
              fontSize: 14,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Indicador discreto da versão
          Text(
            verse.version.toUpperCase(),
            style: TextStyle(
              fontSize: 10, 
              color: Colors.grey[300]
            ),
          ),
        ],
      ),
    );
  }
}