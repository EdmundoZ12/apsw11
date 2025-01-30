

import '../datos/datos_estudiante.dart';
import '../datos/datos_padre.dart';
import '../datos/datos_profesor.dart';
import '../utils/variables.dart';

class PerfilService {
  // Método para obtener los datos de perfil basados en el rol de usuario
  Map<String, String> getUserProfileData() {

    
    if (userRole == profesor) { // Profesor
      return {
        "firstName": DataTeacher().name ?? '',
        "lastName": "",  // Puedes ajustar el nombre completo aquí si necesitas dividirlo
        "position": "Profesor",
        "email": DataTeacher().email ?? '',
        "code": DataTeacher().identification ?? ''
      };
    } else if (userRole == estudiante) { // Estudiante
      return {
        "firstName": DataStudent().name ?? '',
        "lastName": "", // Igual que arriba, ajustar según el nombre completo
        "position": "Estudiante",
        "email": DataStudent().email ?? '',
        "code": DataStudent().identification ?? ''
      };
    } else if (userRole == representante) { // Padre
      return {
        "firstName": DataParent().name ?? '',
        "lastName": "",  // Ajustar si es necesario
        "position": "Representante",
        "email": DataParent().email ?? '',
        "code": DataParent().identification ?? ''
      };
    } else {
      return {
        "firstName": "Administrador",
        "lastName": "", // Igual que arriba, ajustar según el nombre completo
        "position": "Administrador Academico",
        "email": "admin@gmail.com",
        "code": "12ADCG65S"
      }; // En caso de que no se identifique el rol
    }
  }
}
