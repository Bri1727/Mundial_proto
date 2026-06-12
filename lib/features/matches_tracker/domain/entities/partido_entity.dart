class PartidoEntity {
  final String id;
  final EquipoEntity equipoLocal;
  final EquipoEntity equipoVisitante;
  final DateTime fecha;
  final EstadioEntity estadio;
  final String? grupo;
  final String fase;
  final String estado;
  final int? golesLocal;
  final int? golesVisitante;

  const PartidoEntity({
    required this.id,
    required this.equipoLocal,
    required this.equipoVisitante,
    required this.fecha,
    required this.estadio,
    this.grupo,
    required this.fase,
    required this.estado,
    this.golesLocal,
    this.golesVisitante,
  });
}

class EquipoEntity {
  final String id;
  final String nombre;
  final String nombreCorto;
  final String? escudo;

  const EquipoEntity({
    required this.id,
    required this.nombre,
    required this.nombreCorto,
    this.escudo,
  });
}

class EstadioEntity {
  final String id;
  final String nombre;
  final String ciudad;

  const EstadioEntity({
    required this.id,
    required this.nombre,
    required this.ciudad,
  });
}
