import 'package:agenda_academica_app/service/eventService.dart';
import 'package:agenda_academica_app/utils/variables.dart';
import 'package:flutter/material.dart';
import '../../components/custom_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/events.dart';
import 'componentes/descripcion.dart';

class ComunicadosPage extends StatefulWidget {
  const ComunicadosPage({super.key});

  @override
  _ComunicadosPageState createState() => _ComunicadosPageState();
}

class _ComunicadosPageState extends State<ComunicadosPage> {
  final EventService _comunicadosService = EventService();
  List<Event> comunicados = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchComunicados();
  }

  Future<void> _fetchComunicados() async {
    try {
      final fetchedComunicados =
          await _comunicadosService.fetchFilteredEvents();
      setState(() {
        comunicados = fetchedComunicados;
        isLoading = false;
      });
    } catch (e) {
      print("Error al cargar comunicados: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunicados'),
        backgroundColor: theme.colorScheme.primary,
      ),
      drawer: CustomDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: comunicados.length,
              itemBuilder: (context, index) {
                final comunicado = comunicados[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: theme.colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comunicado.title,
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Tipo: ${comunicado.eventType}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Fecha: ${comunicado.start} - ${comunicado.end}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Responsable: ${comunicado.responsibleId[1]}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 10),
                        ContentViewer(
                          htmlContent: comunicado.description,
                          baseUrl: rutaOdoo, // Ajusta según tu configuración
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Método para abrir URLs (enlaces, videos y archivos)
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("No se pudo abrir el enlace: $url");
    }
  }
}
