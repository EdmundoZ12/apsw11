import 'package:flutter/material.dart';
import '../components/custom_drawer.dart';
import '../service/perfilService.dart';

class ProfilePage extends StatelessWidget {
  final PerfilService perfilService = PerfilService();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener datos del perfil desde PerfilService
    final profileData = perfilService.getUserProfileData();
    final firstName = profileData["firstName"] ?? '';
    final lastName = profileData["lastName"] ?? '';
    final position = profileData["position"] ?? '';
    final email = profileData["email"] ?? '';
    final code = profileData["code"] ?? '';

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil',
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      drawer: CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.colorScheme.primary.withOpacity(0.1), theme.colorScheme.primary],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildProfileHeader(firstName, lastName, position, theme),
              const SizedBox(height: 20.0),
              _buildProfileInfo('Nombres', firstName, theme),
              _buildProfileInfo('Apellidos', lastName, theme),
              _buildProfileInfo('Cargo', position, theme),
              _buildProfileInfo('Correo', email, theme),
              _buildProfileInfo('Código', code, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String firstName, String lastName, String position, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surface,
          ),
          child: Icon(
            Icons.person,
            size: 50.0,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$firstName $lastName',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5.0),
            Text(
              position,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileInfo(String label, String value, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: theme.colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
