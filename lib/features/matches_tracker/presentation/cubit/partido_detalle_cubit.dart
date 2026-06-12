import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failure.dart';
import '../../../matches_tracker/domain/entities/partido_entity.dart';
import '../../../matches_tracker/domain/usecases/obtener_detalle_partido.dart';

part 'partido_detalle_estado.dart';

class PartidoDetalleCubit extends Cubit<PartidoDetalleEstado> {
  final ObtenerDetallePartido _obtenerDetallePartido;

  PartidoDetalleCubit(this._obtenerDetallePartido) : super(PartidoDetalleInicial());

  Future<void> cargarDetalle(String id) async {
    emit(PartidoDetalleCargando());
    final resultado = await _obtenerDetallePartido.ejecutar(id);
    resultado.fold(
      (failure) => emit(
        PartidoDetalleError(mensaje: _mensajeError(failure)),
      ),
      (partido) => emit(
        PartidoDetalleCargado(partido: partido),
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
