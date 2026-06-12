import '../../domain/entities/partido_entity.dart';

class PartidoModel {
  final String id;
  final EquipoModel equipoLocal;
  final EquipoModel equipoVisitante;
  final String fecha;
  final EstadioModel estadio;
  final String? grupo;
  final String fase;
  final String estado;
  final int? golesLocal;
  final int? golesVisitante;

  const PartidoModel({
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

  factory PartidoModel.fromJson(Map<String, dynamic> json) {
    final score = json['score'] as Map<String, dynamic>?;
    final fullTime = score?['fullTime'] as Map<String, dynamic>?;

    return PartidoModel(
      id: json['id']?.toString() ?? '',
      equipoLocal: EquipoModel.fromJson(json['homeTeam'] as Map<String, dynamic>? ?? {}),
      equipoVisitante:
          EquipoModel.fromJson(json['awayTeam'] as Map<String, dynamic>? ?? {}),
      fecha: json['utcDate'] as String? ?? json['fecha'] as String? ?? '',
      estadio: EstadioModel.desdeNombre(json['venue'] as String?),
      grupo: _normalizarGrupo(json['group'] as String?),
      fase: json['stage'] as String? ?? '',
      estado: json['status'] as String? ?? '',
      golesLocal: fullTime?['home'] as int?,
      golesVisitante: fullTime?['away'] as int?,
    );
  }

  static String? _normalizarGrupo(String? grupo) {
    if (grupo == null) return null;
    return grupo.replaceFirst('GROUP_', '');
  }

  PartidoEntity toEntity() {
    return PartidoEntity(
      id: id,
      equipoLocal: equipoLocal.toEntity(),
      equipoVisitante: equipoVisitante.toEntity(),
      fecha: DateTime.tryParse(fecha) ?? DateTime.now(),
      estadio: estadio.toEntity(),
      grupo: grupo,
      fase: fase,
      estado: estado,
      golesLocal: golesLocal,
      golesVisitante: golesVisitante,
    );
  }
}

class EquipoModel {
  final String id;
  final String nombre;
  final String nombreCorto;
  final String? escudo;

  const EquipoModel({
    required this.id,
    required this.nombre,
    required this.nombreCorto,
    this.escudo,
  });

  factory EquipoModel.fromJson(Map<String, dynamic> json) {
    return EquipoModel(
      id: json['id']?.toString() ?? '',
      nombre: json['name'] as String? ?? '',
      nombreCorto: json['shortName'] as String? ?? json['tla'] as String? ?? '',
      escudo: json['crest'] as String?,
    );
  }

  EquipoEntity toEntity() {
    return EquipoEntity(
      id: id,
      nombre: nombre,
      nombreCorto: nombreCorto,
      escudo: escudo,
    );
  }
}

class EstadioModel {
  final String id;
  final String nombre;
  final String ciudad;

  const EstadioModel({
    required this.id,
    required this.nombre,
    required this.ciudad,
  });

  factory EstadioModel.desdeNombre(String? venue) {
    return EstadioModel(
      id: '',
      nombre: venue ?? 'Por definir',
      ciudad: '',
    );
  }

  EstadioEntity toEntity() {
    return EstadioEntity(
      id: id,
      nombre: nombre,
      ciudad: ciudad,
    );
  }
}
