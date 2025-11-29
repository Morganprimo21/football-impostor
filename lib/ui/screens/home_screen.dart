import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/premium_provider.dart';
import '../../utils/page_transitions.dart';
import '../widgets/ad_banner_widget.dart';
import '../widgets/vector_logo.dart';
import 'quick_game_setup_screen.dart';
import 'tournament_setup_screen.dart';
import 'tutorial_screen.dart';
import 'premium_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPremium = Provider.of<PremiumProvider>(context).isPremium;

    return Scaffold(
      backgroundColor: const Color(0xFF1B2E28), // Verde oscuro consistente
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        title: const SizedBox.shrink(),
        leading:           Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 8.0),
          child: TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                PageTransitions.slideFromBottom(const PremiumScreen()),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            icon: Icon(
              isPremium ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 26,
            ),
            label: const Text(
              'Premium',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        leadingWidth: 140,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8.0),
            child: IconButton(
              iconSize: 32,
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransitions.slideFromRight(const SettingsScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App logo vectorial (SVG con fallback a JPG)
                    const VectorLogo(
                      width: 250,
                      height: 250,
                    ),
                    const SizedBox(height: 30),
                    
                    // Título con fuente oblicua estilo deportivo
                    Transform(
                      transform: Matrix4.skewX(-0.15), // Inclinación oblicua
                      child: const Text(
                        'FOOTBALL IMPOSTOR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Botón PARTIDA RÁPIDA (verde)
                    _MenuButton(
                      label: 'PARTIDA RÁPIDA',
                      icon: Icons.play_arrow,
                      backgroundColor: const Color(0xFF00A86B),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransitions.scaleWithFade(const QuickGameSetupScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Botón TORNEO (amarillo)
                    _MenuButton(
                      label: 'TORNEO',
                      icon: Icons.emoji_events,
                      backgroundColor: const Color(0xFFC9A021),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransitions.scaleWithFade(const TournamentSetupScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Botón CÓMO JUGAR (morado)
                    _MenuButton(
                      label: 'CÓMO JUGAR',
                      icon: Icons.help_outline,
                      backgroundColor: const Color(0xFF6B1FA8),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransitions.slideAndFadeFromRight(const TutorialScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Banner ad for non-premium users
          if (!isPremium) const AdBannerWidget(),
        ],
      ),
    );
  }
}

// Nuevo botón estilo imagen
class _MenuButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const _MenuButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 240,
          height: 55,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isPressed ? 0.5 : 0.3),
                blurRadius: _isPressed ? 8 : 15,
                offset: Offset(0, _isPressed ? 3 : 6),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
