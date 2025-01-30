import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../components/custom_drawer.dart';
import '../../models/events.dart';
import '../../service/eventService.dart';
import 'conexionGPT/conexion-gpt.dart';
import 'utils.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  _CalendarioPageState createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<Event> _apiEvents = [];
  final EventService eventService = EventService();

  // Agregar variables para speech to text
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    _fetchEvents();
    _initSpeech();
  }

  // Inicializar el reconocimiento de voz
  void _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (errorNotification) => print('Error: $errorNotification'),
    );
    if (!available) {
      print("El dispositivo no soporta reconocimiento de voz");
    }
  }

  // Función para manejar la captura de voz
  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
              if (result.finalResult) {
                _isListening = false;
                _processVoiceCommand(_text);
              }
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  // Función para procesar el comando de voz
  void _processVoiceCommand(String command) {
    // Aquí puedes agregar la lógica para procesar el comando de voz
    print('Comando de voz recibido: $command');
    getEventDetailsFromAI(command, context);
  }

  Future<void> _fetchEvents() async {
    try {
      _apiEvents = await eventService.fetchFilteredEvents();
      _updateSelectedEvents();
    } catch (e) {
      print("Error al cargar eventos: $e");
    }
  }

  void _updateSelectedEvents() {
    if (_selectedDay != null) {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    } else if (_rangeStart != null && _rangeEnd != null) {
      _selectedEvents.value = _getEventsForRange(_rangeStart!, _rangeEnd!);
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    final apiEventsForDay = _apiEvents.where((event) {
      return event.start.year == day.year &&
          event.start.month == day.month &&
          event.start.day == day.day;
    }).toList();

    return apiEventsForDay;
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    final events = <Event>[];

    for (final day in days) {
      events.addAll(_getEventsForDay(day));
    }

    return events;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _updateSelectedEvents();
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    _updateSelectedEvents();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final event = value[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: Text(event.title),
                        subtitle: Text(
                          'Tipo: ${event.eventType}, Prioridad: ${event.priority}, Estado: ${event.state}\nInicio: ${event.start}\nFin: ${event.end}',
                        ),
                        onTap: () => print('Evento: ${event.title}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startListening,
        label: Text(_isListening ? 'Escuchando...' : 'Crear con IA'),
        icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
        backgroundColor: _isListening ? Colors.red : Colors.blue,
      ),
    );
  }
}