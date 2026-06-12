import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/partido_entity.dart';
import '../repositories/partido_repository.dart';

class ObtenerPartidosPorFecha {
  final PartidoRepositorio _repositorio;

  ObtenerPartidosPorFecha(this._repositorio);

  Future<Either<Failure, List<PartidoEntity>>> ejecutar(DateTime fecha) {
    return _repositorio.obtenerPartidosPorFecha(fecha);
  }
}
