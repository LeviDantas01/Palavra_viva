import 'package:flutter/material.dart';

class AudioButton extends StatelessWidget {
  final bool isSpeaking;
  final bool isLoading;
  final VoidCallback onTap;

  const AudioButton({
    super.key,
    required this.isSpeaking,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          // Fica vermelho se estiver falando OU carregando
          color: (isSpeaking || isLoading) ? Colors.redAccent : Colors.black87,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(
                  isSpeaking ? Icons.stop_rounded : Icons.volume_up_rounded,
                  color: Colors.white,
                  size: 20,
                ),
        ),
      ),
    );
  }
}