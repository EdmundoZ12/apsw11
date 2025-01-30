import 'package:flutter/material.dart';
import '../components/custom_drawer.dart';
import '../service/materiasService.dart';
import '../utils/variables.dart';
import 'materias/materiasProfe.dart';

class CursosPage extends StatefulWidget {
  const CursosPage({super.key});

  @override
  _CursosPageState createState() => _CursosPageState();
}

class _CursosPageState extends State<CursosPage> {
  final MateriasService _materiasService = MateriasService();
  List<Map<String, dynamic>> cursos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCursos();
  }

  Future<void> _fetchCursos() async {
    try {
      final fetchedCursos = await _materiasService.getCursos(courseIds!);

      setState(() {
        cursos = fetchedCursos;
        isLoading = false;
      });
    } catch (e) {
      print("Error al cargar los cursos: $e");
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
        title: const Text('Mis Cursos'),
        backgroundColor: theme.colorScheme.primary,
      ),
      drawer: CustomDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cursos.length,
              itemBuilder: (context, index) {
                final curso = cursos[index];
                print("curso: $curso");
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: theme.colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          curso['name'],
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Código: ${curso['code']}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Período: ${curso['period_id'][1]}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Nivel: ${curso['level_id'][1]}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Paralelo: ${curso['parallel_id'][1]}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Navegar a la página de Materias con el ID del curso seleccionado
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MateriasProfePage(courseId: curso['id']),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                          ),
                          child: Text(
                            'Ver Materias',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
