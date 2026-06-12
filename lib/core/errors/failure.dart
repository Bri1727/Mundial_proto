abstract class Failure {
  final String mensaje;
  final int? codigoHttp;

  const Failure({required this.mensaje, this.codigoHttp});
}

class FailureServidor extends Failure {
  const FailureServidor({required super.mensaje, super.codigoHttp});
}

class FailureRed extends Failure {
  const FailureRed({required super.mensaje});
}

class FailureTimeout extends Failure {
  const FailureTimeout({required super.mensaje});
}

class FailureInesperado extends Failure {
  const FailureInesperado({required super.mensaje});
}
