import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/premium_provider.dart';
import 'premium_screen.dart';
import '../widgets/primary_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Widget _sectionCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1A29),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = Provider.of<PremiumProvider>(context).isPremium;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          _sectionCard(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.language)),
              title: const Text('Idioma', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Español'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          _sectionCard(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.help_outline)),
              title: const Text('Cómo jugar', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Aprender las reglas'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(child: Icon(Icons.upgrade)),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('Actualizar a Premium', style: TextStyle(fontWeight: FontWeight.bold))),
                    ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen())),
                      child: const Text('Actualizar'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(left: 56.0),
                  child: Text('Desbloquear todas las funciones y quitar anuncios.'),
                ),
              ],
            ),
          ),
          _sectionCard(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.star_border)),
              title: const Text('Calificar App', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('¿Te encanta el juego? Deja una reseña'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          _sectionCard(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.feedback_outlined)),
              title: const Text('Enviar Comentarios', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Comparte ideas para mejoras'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Text('Otras aplicaciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          _sectionCard(
            child: ListTile(
              leading: Image.asset('assets/hector_icon.png', width: 48, height: 48, errorBuilder: (_, __, ___) => const Icon(Icons.apps)),
              title: const Text('Fiesta de Charadas', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Row(children: const [Icon(Icons.star, size: 14), SizedBox(width: 6), Text('4.8  NUEVO')]),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Text('Información de la App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.info_outline)),
                  title: Text('Versión de la App'),
                  subtitle: Text('1.0.0 (1)'),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person_outline)),
                  title: Text('ID de Cliente'),
                  subtitle: Text('RCAnonymousID:xxxxxxxxxxxxxxxxxxxxxxxx'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}


