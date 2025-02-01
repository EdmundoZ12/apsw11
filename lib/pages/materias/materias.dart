import 'package:flutter/material.dart';
import '../../components/custom_drawer.dart';
import '../../service/materiasService.dart';
import '../../utils/variables.dart';

class MateriasPage extends StatefulWidget {
  const MateriasPage({super.key});

  @override
  _MateriasPageState createState() => _MateriasPageState();
}

class _MateriasPageState extends State<MateriasPage> {
  final MateriasService _materiasService = MateriasService();
  List<Map<String, dynamic>> materias = [];
  String nombreCurso = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMaterias();
  }

  Future<void> _fetchMaterias() async {
    try {
      // Obtener curso y sus materias
      final cursoData =
          await _materiasService.getCurso(cursoId); // Ajusta cursoId y userId
      setState(() {
        nombreCurso = cursoData["courseName"];
      });

      // Obtener cada materia usando los subject_ids
      final List<Map<String, dynamic>> fetchedMaterias = [];
      for (int subjectId in cursoData["subjectIds"]) {
        final materiaData = await _materiasService.getMateria(subjectId);
        fetchedMaterias.add(materiaData);
      }

      setState(() {
        materias = fetchedMaterias;
        isLoading = false;
      });
    } catch (e) {
      print("Error al cargar materias: $e");
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
        title: Text('Materias - $nombreCurso'),
        backgroundColor: theme.colorScheme.primary,
      ),
      drawer: CustomDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: materias.length,
              itemBuilder: (context, index) {
                final materia = materias[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: theme.colorScheme.surface,
                  child: ListTile(
                    title: Text(
                      materia['name'],
                      style: theme.textTheme.titleLarge,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Código: ${materia['code']}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Descripción: ${materia['description']}',
                          style: theme.textTheme.bodyMedium,
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
