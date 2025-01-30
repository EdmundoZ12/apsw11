class Usuario {
  final String name;
  final String user;
  final String password;
  final int idUser;

  Usuario({
    required this.name,
    required this.user,
    required this.password,
    required this.idUser,
  });
}

final List<Usuario> usuarios = [
  Usuario(name: 'admin', user: 'admin@gmail.com', password: '1234', idUser: 1),
  Usuario(name: 'alumno', user: 'alum@gmail.com', password: '1234', idUser: 2),
  Usuario(name: 'profesor', user: 'profe@gmail.com', password: '1234', idUser: 3),
  Usuario(name: 'tutor', user: 'tutor@gmail.com', password: '1234', idUser: 4),
];

bool validarUsuario(String email, String password) {
  for (var usuario in usuarios) {
    if (usuario.user == email && usuario.password == password) {
      return true;
    }
  }
  return false;
}
