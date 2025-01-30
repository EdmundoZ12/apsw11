// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:agenda_academica_app/utils/variables.dart';
import 'package:http/http.dart' as http;

import '../datos/datos_estudiante.dart';
import '../datos/datos_padre.dart';
import '../datos/datos_profesor.dart';

class AuthService {
  Future<int?> login(String email, String password) async {
    // Definir la URL de autenticación
    final url = Uri.parse(ipOdoo);

    // Construir el cuerpo de la solicitud JSON
    final requestBody = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "common",
        "method": "authenticate",
        "args": [dbName, email, password, {}]
      },
      "id": 1
    };
    print(requestBody);
    try {
      // Realizar la solicitud POST
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(response.body);
        // Comprobar si se obtuvo un resultado válido
        if (jsonResponse["result"] != null) {
          return jsonResponse[
              "result"]; // Devuelve el ID de usuario si el login es exitoso
        } else {
          print("Error en autenticación: ${jsonResponse['error']}");
          return null;
        }
      } else {
        print("Error HTTP: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error de conexión: $e");
      return null;
    }
  }

  Future<int> checkRolUser(int userId, String password) async {
    final url = Uri.parse(ipOdoo);
    final requestBody = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          dbName,
          superid, // ID del usuario autenticado
          superPassword, // Contraseña del usuario
          "res.users", // Modelo en Odoo para los usuarios
          "read", // Método para leer detalles
          [
            [userId]
          ], // ID del usuario cuyo rol se desea verificar
          {
            "fields": ["id", "name", "email", "groups_id"] // Campos a leer
          }
        ]
      },
      "id": 3
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse["result"] != null) {
          // Obtén el groups_id del usuario
          List<dynamic> groups = jsonResponse["result"][0]["groups_id"];

          // Verifica el tipo de usuario con base en el contenido de groups_id
          if (groups.contains(estudiante)) {
            await saveDataStudent(userId);
            return estudiante; //estudiante
          } else if (groups.contains(representante)) {
            await saveDataParent(userId);
            return representante; //padre/representante
          } else if (groups.contains(profesor)) {
            await saveDataTeacher(userId);
            return profesor; //profesor
          } else {
            return 1; //admin
          }
        } else {
          print("Error en la obtención de roles: ${jsonResponse['error']}");
          return 0;
        }
      } else {
        print("Error HTTP: ${response.statusCode}");
        return 0;
      }
    } catch (e) {
      print("Error de conexión: $e");
      return 0;
    }
  }

  Future<void> saveDataStudent(int userId) async {
    final url = Uri.parse(ipOdoo);

    final requestBody = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          dbName, // Nombre de la base de datos
          superid, // ID del usuario autenticado
          superPassword, // Contraseña del usuario
          "academy.student", // Modelo en Odoo
          "search_read", // Método para leer datos
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
      final List<dynamic> result = data["result"];

      if (result.isNotEmpty) {
        final studentData = result[0];

        // Guardar los datos del estudiante en DataStudent
        DataStudent().setData(studentData);
      }
    } else {
      throw Exception('Failed to fetch student data');
    }
  }

  Future<void> saveDataTeacher(int userId) async {
    final url = Uri.parse(ipOdoo);

    final requestBody = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          dbName, // Nombre de la base de datos
          superid, // ID del usuario autenticado
          superPassword, // Contraseña del usuario
          "academy.teacher", // Modelo en Odoo
          "search_read", // Método para leer datos
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
      final List<dynamic> result = data["result"];

      if (result.isNotEmpty) {
        final teacherData = result[0];

        // Guardar los datos del profesor en DataTeacher
        DataTeacher().setData(teacherData);
      }
    } else {
      throw Exception('Failed to fetch teacher data');
    }
  }

  Future<void> saveDataParent(int userId) async {
    final url = Uri.parse(ipOdoo);

    final requestBody = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          dbName, // Nombre de la base de datos
          superid, // ID del usuario autenticado
          superPassword, // Contraseña del usuario
          "academy.parent", // Modelo en Odoo
          "search_read", // Método para leer datos
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
      final List<dynamic> result = data["result"];

      if (result.isNotEmpty) {
        final parentData = result[0];

        // Guardar los datos del padre en DataParent
        DataParent().setData(parentData);
      }
    } else {
      throw Exception('Failed to fetch parent data');
    }
  }
}

Future<void> registerTokenDevice() async {
  // Define los datos de la solicitud
  final Map<String, dynamic> requestData = {
    "token": tokenDevice,
    "device_name": "Dispositivo movil $userId",
    "user_id": userId
  };

  // Define el endpoint de la API
  final url = Uri.parse("${rutaOdoo}api/fcm/register");

  try {
    // Envía la solicitud POST
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    // Verifica el código de estado de la respuesta
    if (response.statusCode == 200) {
      print("Token registrado exitosamente: ${response.body}");
    } else {
      print(
          "Error al registrar el token: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Error en la solicitud: $e");
  }
}
