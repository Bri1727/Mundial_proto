import 'package:flutter/material.dart';

class MensajeError extends StatelessWidget {
  final String mensaje;
  final VoidCallback? onReintentar;

  const MensajeError({
    super.key,
    required this.mensaje,
    this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: tema.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Algo salió mal',
              style: tema.textTheme.titleLarge?.copyWith(
                color: tema.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: tema.textTheme.bodyMedium?.copyWith(
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onReintentar != null) ...[
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                onPressed: onReintentar,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
