import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/variables.dart';
import '../models/events.dart'; // Asegúrate de que DataUser tenga userRole y userId

class EventService {
  // Obtiene los eventos de la API de Odoo y los filtra según el tipo de usuario
  Future<List<Event>> fetchFilteredEvents() async {
    final url = Uri.parse(ipOdoo);

    final requestBody = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          dbName,          // Nombre de la base de datos
          superid,         // ID del usuario autenticado
          superPassword,    // Contraseña del usuario
          "academy.event", // Modelo en Odoo
          "search_read",   // Método para leer datos
          [],
          {
            "fields": [
              "name",
              "start_date",
              "end_date",
              "event_type",
              "priority",
              "state",
              "description",
              "creator_type",
              "is_admin_event",
              "is_teacher_event",
              "teacher_ids",
              "student_ids",
              "course_ids",
              "responsible_id"
            ]
          }
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
      final List<dynamic> result = data["result"];

      final List<Event> allEvents = result.map((eventData) {
        final name = eventData['name'] ?? 'Sin título';
        final start = DateTime.parse(eventData['start_date']);
        final end = DateTime.parse(eventData['end_date']);
        final eventType = eventData['event_type'];
        final priority = eventData['priority'];
        final state = eventData['state'];
        final description = eventData['description'].toString();
        final creatorType = eventData['creator_type'];
        final isAdminEvent = eventData['is_admin_event'] ?? false;
        final isTeacherEvent = eventData['is_teacher_event'] ?? false;
        final teacherIds = List<int>.from(eventData['teacher_ids'] ?? []);
        final studentIds = List<int>.from(eventData['student_ids'] ?? []);
        final courseIds = List<int>.from(eventData['course_ids'] ?? []);
        final responsibleId = List<dynamic>.from(eventData['responsible_id']??[]);

        return Event(
          title: name,
          start: start,
          end: end,
          eventType: eventType,
          priority: priority,
          state: state,
          description: description,
          creatorType: creatorType,
          isAdminEvent: isAdminEvent,
          isTeacherEvent: isTeacherEvent,
          teacherIds: teacherIds,
          studentIds: studentIds,
          courseIds: courseIds,
          responsibleId: responsibleId,
        );
      }).toList();

      // Filtrado de eventos según el rol del usuario
      final filteredEvents = _filterEventsByUserRole(allEvents);

      return filteredEvents;
    } else {
      throw Exception('Failed to load events');
    }
  }

  List<Event> _filterEventsByUserRole(List<Event> events) {

    return events.where((event) {
      if (userRole == 1) { // Administrador
        return event.isAdminEvent || event.creatorType == 'admin';
      } else if (userRole == profesor) { // Profesor
        return event.isTeacherEvent ||
            event.creatorType == 'teacher' ||
            event.teacherIds.contains(profeId);
      } else if (userRole == estudiante) { // Estudiante
        return event.creatorType == 'student' ||
            event.studentIds.contains(studentId) ||
            event.courseIds.contains(cursoId);
      }
      return false;
    }).toList();
  }
}
