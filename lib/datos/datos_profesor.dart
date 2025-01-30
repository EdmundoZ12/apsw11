class DataTeacher {
  static final DataTeacher _instance = DataTeacher._internal();

  int? teacherId;
  String? image;
  String? name;
  String? identification;
  String? birthDate;
  String? gender;
  String? email;
  String? phone;
  String? mobile;
  String? address;
  List<String>? specialty;
  String? educationLevel;
  int? yearsExperience;
  String? hireDate;
  List<int>? scheduleIds;
  List<int>? courseIds;
  int? maxHours;
  double? currentHours;

  factory DataTeacher() {
    return _instance;
  }

  DataTeacher._internal();

  // Método para actualizar los datos del profesor
  void setData(Map<String, dynamic> data) {
    teacherId = data['id'];
    image = data['image'].toString();
    name = data['name'];
    identification = data['identification'];
    birthDate = data['birth_date'];
    gender = data['gender'];
    email = data['email'];
    phone = data['phone'].toString();
    mobile = data['mobile'].toString();
    address = data['address'].toString();
    specialty = List<int>.from(data['specialty'] ?? []).cast<String>();
    educationLevel = data['education_level'].toString();
    yearsExperience = data['years_experience'];
    hireDate = data['hire_date'].toString();
    scheduleIds = List<int>.from(data['schedule_ids'] ?? []);
    courseIds = List<int>.from(data['course_ids'] ?? []);
    maxHours = data['max_hours'];
    currentHours = data['current_hours']?.toDouble() ?? 0.0;
  }
}
