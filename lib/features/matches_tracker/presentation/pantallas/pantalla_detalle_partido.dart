import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/partido_entity.dart';
import '../cubit/partido_detalle_cubit.dart';
import '../widgets/mensaje_error.dart';

class PantallaDetallePartido extends StatefulWidget {
  final String partidoId;

  const PantallaDetallePartido({
    super.key,
    required this.partidoId,
  });

  @override
  State<PantallaDetallePartido> createState() => _PantallaDetallePartidoState();
}

class _PantallaDetallePartidoState extends State<PantallaDetallePartido> {
  @override
  void initState() {
    super.initState();
    context.read<PartidoDetalleCubit>().cargarDetalle(widget.partidoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Partido'),
      ),
      body: BlocBuilder<PartidoDetalleCubit, PartidoDetalleEstado>(
        builder: (context, estado) {
          if (estado is PartidoDetalleInicial ||
              estado is PartidoDetalleCargando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (estado is PartidoDetalleError) {
            return MensajeError(
              mensaje: estado.mensaje,
              onReintentar: () =>
                  context.read<PartidoDetalleCubit>().cargarDetalle(widget.partidoId),
            );
          }
          if (estado is PartidoDetalleCargado) {
            return _DetalleContent(partido: estado.partido);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _DetalleContent extends StatelessWidget {
  final PartidoEntity partido;

  const _DetalleContent({required this.partido});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final fechaStr = DateFormat("EEEE d 'de' MMMM 'de' yyyy 'a las' HH:mm", 'es')
        .format(partido.fecha)
        .capitalize();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            partido.fase,
            style: tema.textTheme.titleMedium?.copyWith(
              color: tema.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            fechaStr,
            style: tema.textTheme.bodyMedium?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _EquipoDetalle(
                  nombre: partido.equipoLocal.nombre,
                  nombreCorto: partido.equipoLocal.nombreCorto,
                  alineacionDerecha: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  partido.golesLocal != null && partido.golesVisitante != null
                      ? '${partido.golesLocal} - ${partido.golesVisitante}'
                      : 'VS',
                  style: tema.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: tema.colorScheme.primary,
                  ),
                ),
              ),
              Expanded(
                child: _EquipoDetalle(
                  nombre: partido.equipoVisitante.nombre,
                  nombreCorto: partido.equipoVisitante.nombreCorto,
                  alineacionDerecha: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.location_on,
            label: 'Estadio',
            valor: '${partido.estadio.nombre}, ${partido.estadio.ciudad}',
          ),
          // Se oculta el grupo si es nulo (fases eliminatorias sin grupo)
          if (partido.grupo != null)
            const SizedBox(height: 12),
          if (partido.grupo != null)
            _InfoRow(
              icon: Icons.people,
              label: 'Grupo',
              valor: partido.grupo!,
            ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.info_outline,
            label: 'Estado',
            valor: _estadoTexto(partido.estado),
          ),
        ],
      ),
    );
  }

  String _estadoTexto(String estado) {
    switch (estado.toUpperCase()) {
      case 'SCHEDULED':
      case 'TIMED':
        return 'Programado';
      case 'IN_PLAY':
      case 'LIVE':
        return 'En vivo';
      case 'PAUSED':
        return 'En descanso';
      case 'FINISHED':
        return 'Finalizado';
      case 'POSTPONED':
        return 'Aplazado';
      case 'SUSPENDED':
        return 'Suspendido';
      case 'CANCELLED':
        return 'Cancelado';
      case 'AWARDED':
        return 'Walkover';
      default:
        return estado;
    }
  }
}

class _EquipoDetalle extends StatelessWidget {
  final String nombre;
  final String nombreCorto;
  final bool alineacionDerecha;

  const _EquipoDetalle({
    required this.nombre,
    required this.nombreCorto,
    required this.alineacionDerecha,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Column(
      crossAxisAlignment:
          alineacionDerecha ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          nombreCorto,
          style: tema.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: alineacionDerecha ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 4),
        Text(
          nombre,
          style: tema.textTheme.bodyMedium?.copyWith(
            color: tema.colorScheme.onSurfaceVariant,
          ),
          textAlign: alineacionDerecha ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: tema.colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: tema.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            valor,
            style: tema.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

extension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
