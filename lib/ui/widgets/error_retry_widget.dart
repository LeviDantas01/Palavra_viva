import 'package:flutter/material.dart';

class ErrorRetryWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorRetryWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.wifi_off_rounded, color: Colors.grey, size: 40),
        const SizedBox(height: 10),
        const Text("Erro ao carregar."),
        TextButton(
          onPressed: onRetry,
          child: const Text(
            "Tentar novamente",
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    );
  }
}