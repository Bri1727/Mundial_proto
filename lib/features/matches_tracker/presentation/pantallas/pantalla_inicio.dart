import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/partidos_cubit.dart';
import '../widgets/mensaje_error.dart';
import '../widgets/tarjeta_partido.dart';
import 'pantalla_detalle_partido.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  static final _fechaMinima = DateTime(2026, 6, 11);
  static final _fechaMaxima = DateTime(2026, 7, 19);

  DateTime _calcularFechaInicial() {
    final hoy = DateTime.now();
    if (hoy.isBefore(_fechaMinima)) return _fechaMinima;
    if (hoy.isAfter(_fechaMaxima)) return _fechaMaxima;
    return hoy;
  }

  @override
  void initState() {
    super.initState();
    final fechaInicial = _calcularFechaInicial();
    context.read<PartidosCubit>().cargarPartidos(fechaInicial);
  }

  Future<void> _seleccionarFecha(DateTime fechaActual) async {
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: fechaActual,
      firstDate: _fechaMinima,
      lastDate: _fechaMaxima,
      locale: const Locale('es', 'MX'),
      helpText: 'Seleccionar fecha del Mundial',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (seleccionada != null && seleccionada != fechaActual) {
      context.read<PartidosCubit>().cargarPartidos(seleccionada);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mundial 2026'),
        centerTitle: true,
      ),
      body: BlocBuilder<PartidosCubit, PartidosEstado>(
        builder: (context, estado) {
          if (estado is PartidosInicial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (estado is PartidosCargando) {
            return _ContenidoConFecha(
              fecha: estado.fecha,
              onFechaTap: () => _seleccionarFecha(estado.fecha),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          if (estado is PartidosError) {
            return _ContenidoConFecha(
              fecha: estado.fecha,
              onFechaTap: () => _seleccionarFecha(estado.fecha),
              child: MensajeError(
                mensaje: estado.mensaje,
                onReintentar: () => context.read<PartidosCubit>().cargarPartidos(estado.fecha),
              ),
            );
          }
          if (estado is PartidosCargados) {
            return _ContenidoConFecha(
              fecha: estado.fecha,
              onFechaTap: () => _seleccionarFecha(estado.fecha),
              child: estado.partidos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sports_soccer,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay partidos del Mundial en esta fecha',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      itemCount: estado.partidos.length,
                      itemBuilder: (context, index) {
                        final partido = estado.partidos[index];
                        return TarjetaPartido(
                          partido: partido,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<PartidosCubit>(),
                                  child: PantallaDetallePartido(
                                    partidoId: partido.id,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ContenidoConFecha extends StatelessWidget {
  final DateTime fecha;
  final VoidCallback onFechaTap;
  final Widget child;

  const _ContenidoConFecha({
    required this.fecha,
    required this.onFechaTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final fechaStr = DateFormat('EEEE d \'de\' MMMM \'de\' yyyy', 'es').format(fecha);
    final fechaCapitalizada =
        fechaStr[0].toUpperCase() + fechaStr.substring(1);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: InkWell(
            onTap: onFechaTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    fechaCapitalizada,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
