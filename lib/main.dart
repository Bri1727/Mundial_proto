import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/network/dio_client.dart';
import 'features/matches_tracker/data/datasources/partido_remote_data_source.dart';
import 'features/matches_tracker/data/repositories/partido_repository_impl.dart';
import 'features/matches_tracker/domain/usecases/obtener_detalle_partido.dart';
import 'features/matches_tracker/domain/usecases/obtener_partidos_por_fecha.dart';
import 'features/matches_tracker/presentation/cubit/partido_detalle_cubit.dart';
import 'features/matches_tracker/presentation/cubit/partidos_cubit.dart';
import 'features/matches_tracker/presentation/pantallas/pantalla_inicio.dart';

void main() {
  runApp(const MundialApp());
}

class MundialApp extends StatelessWidget {
  const MundialApp({super.key});

  @override
  Widget build(BuildContext context) {
    const baseUrl = 'https://api.football-data.org/v4/matches';
    const apiToken = String.fromEnvironment('API_TOKEN');
    final dioCliente = DioCliente(baseUrl: baseUrl, apiToken: apiToken);
    final dataSource = PartidoRemoteDataSource(dioCliente);
    final repositorio = PartidoRepositorioImpl(dataSource);
    final obtenerPartidos = ObtenerPartidosPorFecha(repositorio);
    final obtenerDetalle = ObtenerDetallePartido(repositorio);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PartidosCubit(obtenerPartidos),
        ),
        BlocProvider(
          create: (_) => PartidoDetalleCubit(obtenerDetalle),
        ),
      ],
      child: MaterialApp(
        title: 'Mundial 2026',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', 'MX'),
          Locale('en', 'US'),
        ],
        locale: const Locale('es', 'MX'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A5C2E),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const PantallaInicio(),
      ),
    );
  }
}
