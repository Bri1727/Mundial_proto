import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/partido_entity.dart';

class TarjetaPartido extends StatelessWidget {
  final PartidoEntity partido;
  final VoidCallback onTap;

  const TarjetaPartido({
    super.key,
    required this.partido,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final hora = DateFormat('HH:mm').format(partido.fecha);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                hora,
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _EquipoColumna(
                      nombre: partido.equipoLocal.nombreCorto,
                      nombreCompleto: partido.equipoLocal.nombre,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _Marcador(
                      golesLocal: partido.golesLocal,
                      golesVisitante: partido.golesVisitante,
                      tema: tema,
                    ),
                  ),
                  Expanded(
                    child: _EquipoColumna(
                      nombre: partido.equipoVisitante.nombreCorto,
                      nombreCompleto: partido.equipoVisitante.nombre,
                      alineacionDerecha: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                partido.estadio.nombre,
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (partido.grupo != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Grupo ${partido.grupo}',
                  style: tema.textTheme.labelSmall?.copyWith(
                    color: tema.colorScheme.secondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EquipoColumna extends StatelessWidget {
  final String nombre;
  final String nombreCompleto;
  final bool alineacionDerecha;

  const _EquipoColumna({
    required this.nombre,
    required this.nombreCompleto,
    this.alineacionDerecha = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alineacionDerecha ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          nombre,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: alineacionDerecha ? TextAlign.right : TextAlign.left,
        ),
        Text(
          nombreCompleto,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: alineacionDerecha ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }
}

class _Marcador extends StatelessWidget {
  final int? golesLocal;
  final int? golesVisitante;
  final ThemeData tema;

  const _Marcador({
    required this.golesLocal,
    required this.golesVisitante,
    required this.tema,
  });

  @override
  Widget build(BuildContext context) {
    if (golesLocal == null || golesVisitante == null) {
      return Text(
        'vs',
        style: tema.textTheme.titleMedium?.copyWith(
          color: tema.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    return Text(
      '$golesLocal - $golesVisitante',
      style: tema.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: tema.colorScheme.primary,
      ),
    );
  }
}
