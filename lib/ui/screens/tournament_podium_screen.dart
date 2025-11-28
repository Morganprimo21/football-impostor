import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'home_screen.dart';

/// Pantalla épica de podio para mostrar el TOP 3 del torneo
class TournamentPodiumScreen extends StatefulWidget {
  final List<MapEntry<String, int>> topPlayers;

  const TournamentPodiumScreen({
    Key? key,
    required this.topPlayers,
  }) : super(key: key);

  @override
  State<TournamentPodiumScreen> createState() => _TournamentPodiumScreenState();
}

class _TournamentPodiumScreenState extends State<TournamentPodiumScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  bool _showThird = false;
  bool _showSecond = false;
  bool _showFirst = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _startPodiumAnimation();
  }

  Future<void> _startPodiumAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mostrar 3er lugar
    if (widget.topPlayers.length >= 3 && mounted) {
      setState(() => _showThird = true);
      await Future.delayed(const Duration(milliseconds: 800));
    }
    
    // Mostrar 2do lugar
    if (widget.topPlayers.length >= 2 && mounted) {
      setState(() => _showSecond = true);
      await Future.delayed(const Duration(milliseconds: 800));
    }
    
    // Mostrar 1er lugar
    if (widget.topPlayers.isNotEmpty && mounted) {
      setState(() => _showFirst = true);
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20.0,
            20.0,
            20.0,
            20.0 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            children: [
              const SizedBox(height: 30),
              
              // Título
              const Icon(Icons.emoji_events, size: 70, color: Colors.amber),
              const SizedBox(height: 16),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.amber.shade300, Colors.amber.shade600],
                ).createShader(bounds),
                child: const Text(
                  '¡TORNEO FINALIZADO!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'TOP 3 JUGADORES',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  letterSpacing: 2,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Podio
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 2do lugar
                      Expanded(
                        child: _showSecond && widget.topPlayers.length >= 2
                            ? _buildPodiumPosition(
                                position: 2,
                                name: widget.topPlayers[1].key,
                                score: widget.topPlayers[1].value,
                                color: Colors.grey.shade400,
                                height: 120,
                              )
                            : const SizedBox.shrink(),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // 1er lugar
                      Expanded(
                        child: _showFirst && widget.topPlayers.isNotEmpty
                            ? _buildPodiumPosition(
                                position: 1,
                                name: widget.topPlayers[0].key,
                                score: widget.topPlayers[0].value,
                                color: Colors.amber,
                                height: 160,
                                isWinner: true,
                              )
                            : const SizedBox.shrink(),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // 3er lugar
                      Expanded(
                        child: _showThird && widget.topPlayers.length >= 3
                            ? _buildPodiumPosition(
                                position: 3,
                                name: widget.topPlayers[2].key,
                                score: widget.topPlayers[2].value,
                                color: Colors.brown.shade400,
                                height: 90,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Botón volver
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.home, size: 24),
                  label: const Text(
                    'VOLVER AL INICIO',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPodiumPosition({
    required int position,
    required String name,
    required int score,
    required Color color,
    required double height,
    bool isWinner = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Corona para el ganador
        if (isWinner) ...[
          const Icon(Icons.emoji_events, size: 40, color: Colors.amber),
          const SizedBox(height: 8),
        ],
        
        // Avatar con número
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.6)],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Center(
            child: Text(
              '$position',
              style: TextStyle(
                fontSize: isWinner ? 36 : 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 10),
        
        // Nombre
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isWinner ? 16 : 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 6),
        
        // Puntos
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color, width: 2),
          ),
          child: Text(
            '$score pts',
            style: TextStyle(
              fontSize: isWinner ? 14 : 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Base del podio
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: color.withOpacity(0.5), width: 2),
          ),
          child: Center(
            child: Icon(
              position == 1 ? Icons.star : Icons.star_border,
              color: Colors.white.withOpacity(0.3),
              size: 36,
            ),
          ),
        ),
      ],
    );
  }
}

