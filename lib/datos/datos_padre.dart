class DataParent {
  static final DataParent _instance = DataParent._internal();

  int? parentId;
  String? name;
  String? identification;
  String? email;
  String? phone;
  String? mobile;
  String? address;
  String? occupation;
  String? workplace;
  String? workPhone;
  List<int>? studentIds;

  factory DataParent() {
    return _instance;
  }

  DataParent._internal();

  // Método para actualizar los datos del padre
  void setData(Map<String, dynamic> data) {
    parentId = data['id'];
    name = data['name'];
    identification = data['identification'];
    email = data['email'];
    phone = data['phone'];
    mobile = data['mobile'];
    address = data['address'];
    occupation = data['occupation'];
    workplace = data['workplace'];
    workPhone = data['work_phone'];
    studentIds = List<int>.from(data['student_ids'] ?? []);
  }
}
