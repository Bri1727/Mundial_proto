import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/partido_entity.dart';

abstract class PartidoRepositorio {
  Future<Either<Failure, List<PartidoEntity>>> obtenerPartidosPorFecha(
    DateTime fecha,
  );

  Future<Either<Failure, PartidoEntity>> obtenerDetallePartido(
    String id,
  );
}
