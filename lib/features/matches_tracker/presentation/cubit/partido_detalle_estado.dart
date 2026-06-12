part of 'partido_detalle_cubit.dart';

abstract class PartidoDetalleEstado extends Equatable {
  const PartidoDetalleEstado();

  @override
  List<Object?> get props => [];
}

class PartidoDetalleInicial extends PartidoDetalleEstado {
  const PartidoDetalleInicial();
}

class PartidoDetalleCargando extends PartidoDetalleEstado {
  const PartidoDetalleCargando();
}

class PartidoDetalleCargado extends PartidoDetalleEstado {
  final PartidoEntity partido;

  const PartidoDetalleCargado({required this.partido});

  @override
  List<Object?> get props => [partido];
}

class PartidoDetalleError extends PartidoDetalleEstado {
  final String mensaje;

  const PartidoDetalleError({required this.mensaje});

  @override
  List<Object?> get props => [mensaje];
}
