import 'package:intl/intl.dart';
import '../../../../core/network/dio_client.dart';
import '../models/partido_model.dart';

class PartidoRemoteDataSource {
  final DioCliente _cliente;

  PartidoRemoteDataSource(this._cliente);

  Future<List<PartidoModel>> obtenerPartidosPorFecha(DateTime fecha) async {
    final fechaStr = DateFormat('yyyy-MM-dd').format(fecha);
    final respuesta = await _cliente.get(
      '/matches',
      parametros: {
        'date': fechaStr,
      },
    );
    final datos = respuesta.data as Map<String, dynamic>? ?? {};
    final lista = datos['matches'] as List<dynamic>? ?? [];
    return lista
        .map((e) => PartidoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PartidoModel> obtenerDetallePartido(String id) async {
    final respuesta = await _cliente.get('/matches/$id');
    final datos = respuesta.data as Map<String, dynamic>? ?? {};
    return PartidoModel.fromJson(datos);
  }
}
