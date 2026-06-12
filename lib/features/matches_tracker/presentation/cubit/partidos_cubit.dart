import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failure.dart';
import '../../../matches_tracker/domain/entities/partido_entity.dart';
import '../../../matches_tracker/domain/usecases/obtener_partidos_por_fecha.dart';

part 'partidos_estado.dart';

class PartidosCubit extends Cubit<PartidosEstado> {
  final ObtenerPartidosPorFecha _obtenerPartidosPorFecha;

  PartidosCubit(this._obtenerPartidosPorFecha) : super(PartidosInicial());

  Future<void> cargarPartidos(DateTime fecha) async {
    emit(PartidosCargando(fecha: fecha));
    final resultado = await _obtenerPartidosPorFecha.ejecutar(fecha);
    resultado.fold(
      (failure) => emit(
        PartidosError(
          fecha: fecha,
          mensaje: _mensajeError(failure),
          error: failure,
        ),
      ),
      (partidos) => emit(
        PartidosCargados(
          partidos: partidos,
          fecha: fecha,
        ),
      ),
    );
  }

  String _mensajeError(Failure failure) {
    if (failure is FailureRed) {
      return 'Sin conexión: ${failure.mensaje}';
    } else if (failure is FailureTimeout) {
      return 'Tiempo agotado: ${failure.mensaje}';
    } else if (failure is FailureServidor) {
      return 'Error del servidor: ${failure.mensaje}';
    }
    return 'Error: ${failure.mensaje}';
  }
}
