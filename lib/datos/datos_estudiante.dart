class DataStudent {
  static final DataStudent _instance = DataStudent._internal();

  int? studentId;
  String? image;
  List<int>? enrollmentIds;
  String? name;
  String? identification;
  String? birthDate;
  String? gender;
  int? age;
  String? email;
  String? phone;
  String? address;
  String? enrollmentDate;
  Map<String, dynamic>? currentCourse;
  List<int>? courseIds;
  String? bloodType;
  String? medicalConditions;
  String? allergies;
  Map<String, dynamic>? parentInfo;
  String? status;
  bool? isActive;

  factory DataStudent() {
    return _instance;
  }

  DataStudent._internal();

  // Método para actualizar los datos del estudiante
  void setData(Map<String, dynamic> data) {
    studentId = data['id'];
    image = data['image'].toString();
    enrollmentIds = List<int>.from(data['enrollment_ids'] ?? []);
    name = data['name'].toString();
    identification = data['identification'].toString();
    birthDate = data['birth_date'].toString();
    gender = data['gender'].toString();
    age = data['age'];
    email = data['email'].toString();
    phone = data['phone'].toString();
    address = data['address'].toString();
    enrollmentDate = data['enrollment_date'].toString();
    currentCourse = {
      "course_id": data['current_course_id'][0],
      "course_name": data['current_course_id'][1]
    };
    courseIds = List<int>.from(data['course_ids'] ?? []);
    bloodType = data['blood_type'].toString();
    medicalConditions = data['medical_conditions'].toString();
    allergies = data['allergies'].toString();
    parentInfo = {
      "parent_id": data['parent_id'][0],
      "parent_name": data['parent_id'][1]
    };
    status = data['status'];
    isActive = data['active'];
  }
}
