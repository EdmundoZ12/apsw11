import 'dart:convert';
import 'dart:io';
import 'package:agenda_academica_app/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> getEventDetailsFromAI(
    String inputText, BuildContext context) async {
  // Mostrar el cuadro de "Procesando"
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Text("Procesando..."),
        ],
      ),
    ),
  );

  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKeyGemini',
  );

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text":
                  "Por favor, analiza el siguiente texto para identificar los datos de un evento y responde en formato JSON. Extrae los datos del nombre del evento, la fecha de inicio (las fechas deben tener este formato: 2024-11-01 10:00:00, y siempre debe ser del año 2024 en adelante) y la fecha de fin (si no se proporciona fecha de inicio le colocas la fecha actual, y si no proporciona fecha de fin le colocas la misma que fecha que la de inicio). Solo proporciona la respuesta en JSON. Ejemplo del formato de respuesta esperado:\n\n{\n  \"name\": \"Nombre del evento\",\n  \"start_date\": \"YYYY-MM-DD HH:MM:SS\",\n  \"end_date\": \"YYYY-MM-DD HH:MM:SS\"\n}\n\nTexto a analizar: \"$inputText\""
            }
          ]
        }
      ]
    }),
  );

  Navigator.of(context).pop(); // Cerrar el diálogo de "Procesando"

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final candidates = data['candidates'];
    if (candidates != null && candidates.isNotEmpty) {
      var eventJsonText = candidates[0]['content']['parts'][0]['text'];
      eventJsonText = eventJsonText
          .replaceAll(RegExp(r'^```json\s*|\s*```$', multiLine: true), '')
          .trim();
      print("eventJsonText: $eventJsonText");
      try {
        final eventDetails = jsonDecode(eventJsonText);
        await createEvent(
            eventDetails, context); // Pasar `context` a `createEvent`
      } catch (e) {
        print('Error al decodificar JSON: $e');
      }
    } else {
      print('No se encontraron datos en la respuesta de Gemini.');
    }
  } else {
    print('Error en la solicitud: ${response.statusCode}');
  }
}

Future<void> getEventDetailsFromImage(
    File imageFile, BuildContext context) async {
  // Mostrar el cuadro de diálogo de "Procesando"
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Text("Procesando imagen..."),
        ],
      ),
    ),
  );

  // Codifica la imagen en base64
  final bytes = await imageFile.readAsBytes();
  final base64Image = base64Encode(bytes);

  // Configura la URL de la Vision API con tu API Key
  final url = Uri.parse(
      'https://vision.googleapis.com/v1/images:annotate?key=$apiKeyGoogle');

  // Configura la solicitud con los parámetros necesarios
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "requests": [
        {
          "image": {"content": base64Image},
          "features": [
            {"type": "TEXT_DETECTION"}
          ] // O el tipo de detección que desees
        }
      ]
    }),
  );

  Navigator.of(context).pop(); // Cerrar el diálogo de "Procesando imagen"

  // Verifica si la respuesta fue exitosa
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // Extraer todos los campos "description" en un solo texto
    final descriptions = data['responses'][0]['textAnnotations']
        ?.map((annotation) => annotation['description'])
        ?.join(' ');

    if (descriptions != null && descriptions.isNotEmpty) {
      print("Texto extraído de la imagen: $descriptions");

      // Llamar a la función para obtener los detalles del evento usando el texto extraído
      await getEventDetailsFromAI(descriptions, context);
    } else {
      print('No se encontró texto en la imagen.');
    }
  } else {
    print('Error en la solicitud: ${response.statusCode} ${response.body}');
  }
}

Future<void> createEvent(
    Map<String, dynamic> geminiResponse, BuildContext context) async {
  final name = geminiResponse['name'] ?? 'Evento sin título';
  final startDate = geminiResponse['start_date'] ?? '2024-11-01T10:00:00';
  final endDate = geminiResponse['end_date'] ?? '2024-11-01T12:00:00';

  final requestBody = {
    "jsonrpc": "2.0",
    "method": "call",
    "params": {
      "service": "object",
      "method": "execute_kw",
      "args": [
        dbName,
        userId,
        userPassword,
        "academy.event",
        "create",
        [
          {
            "name": name,
            "start_date": startDate,
            "end_date": endDate,
            "event_type": "academic"
          }
        ]
      ]
    },
    "id": 3
  };

  final url = Uri.parse(ipOdoo);
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Evento creado"),
        content: Text(
          "Nombre: $name\nInicio: $startDate\nFin: $endDate",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Aceptar"),
          ),
        ],
      ),
    );
  } else {
    print('Error al crear el evento: ${response.statusCode} ${response.body}');
  }
}
