import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/variables.dart';

class MateriasService {
  // Método para obtener el curso y sus materias
  Future<Map<String, dynamic>> getCurso(int courseId) async {
    final url = Uri.parse(ipOdoo);
    final requestBody = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          dbName, superid, superPassword, "academy.course", "read", [[courseId]],
          {"fields": ["name", "subject_ids"]}
        ]
      },
      "id": 1
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final courseData = data["result"][0];
      return {
        "courseName": courseData["name"],
        "subjectIds": List<int>.from(courseData["subject_ids"])
      };
    } else {
      throw Exception('Error al obtener el curso');
    }
  }

  // Método para obtener los detalles de una materia
  Future<Map<String, dynamic>> getMateria(int materiaId) async {
    final url = Uri.parse(ipOdoo);
    final requestBody = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          dbName, superid, superPassword, "academy.subject", "read", [[materiaId]],
          {"fields": ["id", "name", "code", "description"]}
        ]
      },
      "id": 2
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["result"][0];
    } else {
      throw Exception('Error al obtener los datos de la materia');
    }
  }

  Future<List<Map<String, dynamic>>> getCursos(List<int> courseIds) async {
    final url = Uri.parse(ipOdoo);
    final List<Map<String, dynamic>> courses = [];

    for (int courseId in courseIds) {
      final requestBody = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "service": "object",
          "method": "execute_kw",
          "args": [
            dbName, superid, superPassword, "academy.course", "read", [[courseId]],
            {
              "fields": ["name", "subject_ids", "code", "period_id", "level_id", "parallel_id"]
            }
          ]
        },
        "id": 1
      };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        courses.add(data["result"][0]);
      } else {
        throw Exception('Error al obtener los cursos');
      }
    }

    return courses;
  }
}
