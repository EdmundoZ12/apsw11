import 'dart:convert';
import 'package:agenda_academica_app/utils/variables.dart';
import 'package:http/http.dart' as http;

class HijosService {
  // Contraseña del usuario

  HijosService();

  // Función para obtener IDs de los hijos
  Future<List<int>> fetchChildrenIds() async {
    final url = Uri.parse(ipOdoo);

    final requestBody = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          dbName,
          superid,
          userPassword,
          "academy.parent",
          "search_read",
          [
            [
              ["user_id", "=", userId]
            ]
          ]
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
      print('Padre e hijos: $data');
      final result = data['result'] as List;
      if (result.isNotEmpty) {
        final idStudents = List<int>.from(result[0]["student_ids"]);
        print("Id's de los hijos: $idStudents");
        return List<int>.from(result[0]["student_ids"]);
      }
    } else {
      throw Exception('Failed to fetch children IDs');
    }
    return [];
  }

  // Función para obtener detalles de matrícula por cada hijo
  Future<Map<String, dynamic>> fetchChildEnrollment(int studentId) async {
    final url = Uri.parse(ipOdoo);
    print("studentId: $studentId");
    final requestBody = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          dbName,
          superid,
          userPassword,
          "academy.enrollment",
          "search_read",
          [
            [
              ["student_id", "=", studentId]
            ]
          ]
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
      final result = data['result'] as List;
      print("Matricula: $result");
      return result.isNotEmpty ? result[0] as Map<String, dynamic> : {};
    } else {
      throw Exception('Failed to fetch enrollment details');
    }
  }
}
