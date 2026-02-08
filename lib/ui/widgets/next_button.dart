import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const NextButton({
    super.key,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Se estiver carregando, desativa o clique
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black87, // Cor padrão
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Icon(
          // Ícone de "Próximo" ou "Refresh"
          Icons.refresh_rounded, 
          color: isLoading ? Colors.grey : Colors.white,
          size: 22,
        ),
      ),
    );
  }
}