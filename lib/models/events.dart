class Event {
  final String title;
  final DateTime start;
  final DateTime end;
  final String eventType;
  final String priority;
  final String state;
  final String description;
  final String creatorType;
  final bool isAdminEvent;
  final bool isTeacherEvent;
  final List<int> teacherIds;
  final List<int> studentIds;
  final List<int> courseIds;
  final List<dynamic> responsibleId;

  Event({
    required this.title,
    required this.start,
    required this.end,
    required this.eventType,
    required this.priority,
    required this.state,
    required this.description,
    required this.creatorType,
    required this.isAdminEvent,
    required this.isTeacherEvent,
    required this.teacherIds,
    required this.studentIds,
    required this.courseIds, 
    required this.responsibleId,
  });

  @override
  String toString() => title;
}
