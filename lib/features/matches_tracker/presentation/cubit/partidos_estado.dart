part of 'partidos_cubit.dart';

abstract class PartidosEstado extends Equatable {
  const PartidosEstado();

  @override
  List<Object?> get props => [];
}

class PartidosInicial extends PartidosEstado {
  const PartidosInicial();
}

class PartidosCargando extends PartidosEstado {
  final DateTime fecha;
  const PartidosCargando({required this.fecha});

  @override
  List<Object?> get props => [fecha];
}

class PartidosCargados extends PartidosEstado {
  final List<PartidoEntity> partidos;
  final DateTime fecha;

  const PartidosCargados({
    required this.partidos,
    required this.fecha,
  });

  @override
  List<Object?> get props => [partidos, fecha];
}

class PartidosError extends PartidosEstado {
  final DateTime fecha;
  final String mensaje;
  final Failure error;

  const PartidosError({
    required this.fecha,
    required this.mensaje,
    required this.error,
  });

  @override
  List<Object?> get props => [fecha, mensaje, error];
}
