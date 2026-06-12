import 'package:dio/dio.dart';
import '../errors/failure.dart';

class DioCliente {
  late final Dio _dio;

  DioCliente({required String baseUrl, String? apiToken}) {
    final headers = <String, dynamic>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (apiToken != null && apiToken.isNotEmpty) {
      headers['X-Auth-Token'] = apiToken;
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: headers,
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[DIO] $obj'),
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? parametros,
  }) async {
    try {
      var url = path;
      if (parametros != null && parametros.isNotEmpty) {
        final qs = parametros.entries
            .where((e) => e.value != null)
            .map((e) =>
                '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value.toString())}')
            .join('&');
        url = '$path?$qs';
      }
      final respuesta = await _dio.get(url);
      return respuesta;
    } on DioException catch (e) {
      throw _mapearError(e);
    }
  }

  Failure _mapearError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const FailureTimeout(
          mensaje: 'La conexión tardó demasiado. Revisa tu internet e intenta de nuevo.',
        );
      case DioExceptionType.badResponse:
        final codigo = error.response?.statusCode ?? 0;
        final cuerpo = error.response?.data;
        final msgApi = cuerpo is Map ? (cuerpo['message'] ?? cuerpo['error'] ?? '') : '';
        final detalle = msgApi is String && msgApi.isNotEmpty
            ? 'HTTP $codigo: $msgApi'
            : 'Error del servidor (HTTP $codigo). Intenta de nuevo más tarde.';
        return FailureServidor(
          mensaje: detalle,
          codigoHttp: codigo,
        );
      case DioExceptionType.connectionError:
        return const FailureRed(
          mensaje: 'No hay conexión a internet. Verifica tu conexión.',
        );
      case DioExceptionType.cancel:
        return const FailureRed(
          mensaje: 'La solicitud fue cancelada.',
        );
      case DioExceptionType.unknown:
      default:
        return const FailureInesperado(
          mensaje: 'Ocurrió un error inesperado. Intenta de nuevo.',
        );
    }
  }
}
