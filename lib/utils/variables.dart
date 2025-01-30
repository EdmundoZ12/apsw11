// ignore_for_file: file_names
//'10.0.2.2:8069/jsonrpc/'

import 'package:agenda_academica_app/datos/datos_estudiante.dart';
import 'package:agenda_academica_app/datos/datos_padre.dart';
import 'package:agenda_academica_app/datos/datos_profesor.dart';

import '../datos/datos_user.dart';

//para las consultas por http
const ipOdoo =
    'http://192.168.0.54:8069/jsonrpc'; // http://192.168.0.3:8069/jsonrpc  165.227.176.190
const dbName = 'db_parcial'; // prueba
const int superid = 2; //2
const superPassword = 'admin'; // 1234



//para visualizar elementos en los comunicados:
const rutaOdoo =
    'http://192.168.0.54:8069/'; // http://192.168.0.3:8069/   165.227.176.190

//Roles
const int estudiante = 15; //65
const int representante = 16; //66
const int profesor = 17; //67

//Data User
final userId = DataUser().userId;
final userRole = DataUser().userRole;
final userPassword = DataUser().userPassword;

//Data Student
final studentId = DataStudent().studentId;
final cursoId = DataStudent().currentCourse?['course_id'];

//Data Teacher
final profeId = DataTeacher().teacherId;
List<int>? courseIds = DataTeacher().courseIds;

//Data Padre
final padreId = DataParent().parentId;

//Para las notificaciones
String tokenDevice = '';
