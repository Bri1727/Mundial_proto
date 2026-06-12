import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/partido_entity.dart';
import '../repositories/partido_repository.dart';

class ObtenerDetallePartido {
  final PartidoRepositorio _repositorio;

  ObtenerDetallePartido(this._repositorio);

  Future<Either<Failure, PartidoEntity>> ejecutar(String id) {
    return _repositorio.obtenerDetallePartido(id);
  }
}
