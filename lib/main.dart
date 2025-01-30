import 'package:agenda_academica_app/config/app_theme.dart';
import 'package:agenda_academica_app/notificaciones/bloc/notifications_bloc.dart';
import 'package:agenda_academica_app/pages/calendario/calendario.dart';
import 'package:agenda_academica_app/pages/comunicados/comunicados.dart';
import 'package:agenda_academica_app/pages/cursos.dart';
import 'package:agenda_academica_app/pages/hijos.dart';
import 'package:agenda_academica_app/pages/login.dart';
import 'package:agenda_academica_app/pages/materias/materias.dart';
import 'package:agenda_academica_app/pages/perfil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsBloc.initializeFCM();

  runApp(MultiBlocProvider(
      providers: [BlocProvider(create: (_) => NotificationsBloc())],
      child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter APP AGENDA',
        theme: AppTheme(selectedColor: 1).getTheme(),
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/calendario': (context) => const CalendarioPage(),
          '/hijos': (context) => const ChildPage(),
          '/perfil': (context) => ProfilePage(),
          '/materias': (context) => const MateriasPage(),
          '/cursos': (context) => const CursosPage(),
          '/comunicados': (context) => const ComunicadosPage()
        });
  }
}
