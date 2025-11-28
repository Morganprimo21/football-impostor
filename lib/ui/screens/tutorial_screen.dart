import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_colors.dart';
import '../../services/sound_service.dart';
import 'home_screen.dart';

/// Tutorial interactivo que explica que es un juego HABLADO presencial
class TutorialScreen extends StatefulWidget {
  final bool showSkip;
  
  const TutorialScreen({
    Key? key,
    this.showSkip = true,
  }) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  final List<TutorialStep> _steps = [
    TutorialStep(
      icon: Icons.groups,
      title: '¡Juego PRESENCIAL!',
      description: 'Football Impostor se juega en PERSONA con tus amigos. El móvil es solo una herramienta para ayudar.',
      color: AppColors.primary,
      emoji: '🎉',
    ),
    TutorialStep(
      icon: Icons.phone_android,
      title: 'Pasa el Móvil',
      description: 'Cada jugador ve su ROL en privado y pasa el móvil al siguiente. ¡Todo es secreto!',
      color: AppColors.secondary,
      emoji: '📱',
    ),
    TutorialStep(
      icon: Icons.chat_bubble_outline,
      title: 'Jugáis HABLANDO',
      description: 'Dais pistas sobre el jugador secreto HABLANDO. El impostor debe mentir sin que lo descubran.',
      color: AppColors.accent,
      emoji: '💬',
    ),
    TutorialStep(
      icon: Icons.how_to_vote,
      title: 'Votad en Grupo',
      description: 'Después de discutir, señalad al sospechoso CON EL DEDO. La app solo muestra el resultado.',
      color: AppColors.success,
      emoji: '🗳️',
    ),
    TutorialStep(
      icon: Icons.celebration,
      title: '¡A Jugar!',
      description: 'Reunid a 3-12 amigos, sentaos en círculo, y ¡empezad la diversión!',
      color: AppColors.primary,
      emoji: '🎊',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_tutorial', true);
    
    if (mounted) {
      SoundService().playButtonSuccess();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      SoundService().playButtonClick();
    } else {
      _completeTutorial();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      SoundService().playButtonClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: SafeArea(
        child: Column(
          children: [
            // Header con skip
            if (widget.showSkip)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 80),
                    Text(
                      'CÓMO JUGAR',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 2,
                      ),
                    ),
                    TextButton(
                      onPressed: _completeTutorial,
                      child: const Text('SALTAR'),
                    ),
                  ],
                ),
              ),

            // Indicadores de paso
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_steps.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentStep == index ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentStep == index
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),

            // Contenido del tutorial
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _steps.length,
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },
                itemBuilder: (context, index) {
                  return _buildStepContent(_steps[index]);
                },
              ),
            ),

            // Navegación
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _previousStep,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('ATRÁS'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _nextStep,
                      icon: Icon(
                        _currentStep == _steps.length - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                      ),
                      label: Text(
                        _currentStep == _steps.length - 1
                            ? '¡EMPEZAR!'
                            : 'SIGUIENTE',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(TutorialStep step) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji grande
          Text(
            step.emoji,
            style: const TextStyle(fontSize: 120),
          ),
          const SizedBox(height: 32),

          // Icono circular
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: step.color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: step.color,
                width: 3,
              ),
            ),
            child: Icon(
              step.icon,
              size: 64,
              color: step.color,
            ),
          ),
          const SizedBox(height: 32),

          // Título
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: step.color,
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Descripción
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: step.color, width: 2),
            ),
            child: Text(
              step.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                height: 1.6,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialStep {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final String emoji;

  TutorialStep({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.emoji,
  });
}

