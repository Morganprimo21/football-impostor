import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../providers/premium_provider.dart';
import '../widgets/ad_banner_widget.dart';
import 'lobby_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int playerCount = 4;
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 12; i++) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = Provider.of<PremiumProvider>(context).isPremium;

    return Scaffold(
      // Fondo con degradado sutil
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF121212), Color(0xFF1E1E2C)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'FOOTBALL\nIMPOSTOR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Theme.of(context).colorScheme.primary,
                      shadows: [
                        Shadow(
                            blurRadius: 10,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withAlpha(128),
                            offset: const Offset(0, 0)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Control de Jugadores
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nº JUGADORES',
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButton<int>(
                          value: playerCount,
                          dropdownColor: const Color(0xFF2C2C2C),
                          underline: const SizedBox(),
                          icon: Icon(Icons.arrow_drop_down,
                              color: Theme.of(context).colorScheme.primary),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          items: List.generate(10, (i) => i + 3)
                              .map((v) =>
                                  DropdownMenuItem(value: v, child: Text('$v')))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => playerCount = v ?? 4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Lista de Nombres
                Expanded(
                  child: ListView.separated(
                    itemCount: playerCount,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return TextField(
                        controller: _controllers[index],
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_outline,
                              color: Colors.grey[400]),
                          hintText: 'Nombre Jugador ${index + 1}',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Botón Principal
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      final names = List<String>.generate(
                          playerCount,
                          (i) => _controllers[i].text.trim().isEmpty
                              ? 'Agente ${i + 1}'
                              : _controllers[i].text.trim());

                      final gp = GameProvider();
                      try {
                        await gp.loadPlayersAsset();
                        gp.setPlayerNames(names);
                        gp.assignRolesAndSecrets(); // Asignamos roles aquí para ir directos al nuevo tablero

                        if (!mounted) return;

                        // Vamos directos a la nueva pantalla de selección de roles (LobbyScreen rediseñado)
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider.value(
                                    value: gp, child: const LobbyScreen())));
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.redAccent),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      elevation: 8,
                      shadowColor:
                          Theme.of(context).colorScheme.primary.withAlpha(128),
                    ),
                    child: const Text('INICIAR MISIÓN',
                        style: TextStyle(fontSize: 18, letterSpacing: 1)),
                  ),
                ),

                // Botón Premium secundario
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Próximamente: Eliminar Anuncios')),
                    );
                  },
                  child: Text('Quitar Anuncios',
                      style: TextStyle(color: Colors.grey[500])),
                ),

                const SizedBox(height: 8),
                if (!isPremium) const AdBannerWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
