import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/partido_entity.dart';
import '../../domain/repositories/partido_repository.dart';
import '../datasources/partido_remote_data_source.dart';

class PartidoRepositorioImpl implements PartidoRepositorio {
  final PartidoRemoteDataSource _dataSource;

  PartidoRepositorioImpl(this._dataSource);

  @override
  Future<Either<Failure, List<PartidoEntity>>> obtenerPartidosPorFecha(
    DateTime fecha,
  ) async {
    try {
      final modelos = await _dataSource.obtenerPartidosPorFecha(fecha);
      final entidades = modelos.map((m) => m.toEntity()).toList();
      return Right(entidades);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(
        FailureInesperado(mensaje: 'Error inesperado: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, PartidoEntity>> obtenerDetallePartido(
    String id,
  ) async {
    try {
      final modelo = await _dataSource.obtenerDetallePartido(id);
      return Right(modelo.toEntity());
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(
        FailureInesperado(mensaje: 'Error inesperado: ${e.toString()}'),
      );
    }
  }
}
