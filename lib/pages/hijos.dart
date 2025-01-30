import 'package:flutter/material.dart';
import '../components/custom_drawer.dart';
import '../service/hijosService.dart';

class ChildPage extends StatefulWidget {
  const ChildPage({super.key});

  @override
  _ChildPageState createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  late HijosService hijosService;
  List<Map<String, dynamic>> childrenData = [];

  @override
  void initState() {
    super.initState();
    hijosService = HijosService();
    _fetchChildrenData();
  }

  Future<void> _fetchChildrenData() async {
    try {
      final childrenIds = await hijosService.fetchChildrenIds();
      List<Map<String, dynamic>> tempData = [];

      for (var studentId in childrenIds) {
        final enrollment = await hijosService.fetchChildEnrollment(studentId);
        tempData.add(enrollment);
      }

      setState(() {
        childrenData = tempData;
      });
    } catch (e) {
      print("Error al cargar los datos de los hijos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Hijos'),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: childrenData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: childrenData.length,
                itemBuilder: (context, index) {
                  final child = childrenData[index];
                  return _buildChildCard(
                    name: child['student_id'][1] ?? 'N/A',
                    course: child['course_id'][1] ?? 'N/A',
                    enrollmentDate: child['enrollment_date'] ?? 'N/A',
                    state: child['state'] ?? 'N/A',
                  );
                },
              ),
      ),
    );
  }

  Widget _buildChildCard({
    required String name,
    required String course,
    required String enrollmentDate,
    required String state,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Curso: $course'),
            Text('Fecha de matrícula: $enrollmentDate'),
            Text('Estado: $state'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes implementar la navegación para ver las tareas
              },
              child: const Text('Ver tareas'),
            ),
          ],
        ),
      ),
    );
  }
}
