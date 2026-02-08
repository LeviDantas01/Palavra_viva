import 'package:flutter/material.dart';

class LanguageToggle extends StatelessWidget {
  final String currentLang; // 'nvi' ou 'kjv'
  final bool isDisabled;    // Para bloquear clique durante loading
  final VoidCallback onTap;

  const LanguageToggle({
    super.key,
    required this.currentLang,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildText("PT", currentLang == 'nvi'),
            const SizedBox(width: 10),
            Container(width: 1, height: 15, color: Colors.grey[300]), // Divisória
            const SizedBox(width: 10),
            _buildText("EN", currentLang == 'kjv'),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text, bool isActive) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        color: isActive ? Colors.black : Colors.grey,
      ),
    );
  }
}