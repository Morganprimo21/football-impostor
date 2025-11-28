import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import '../../services/connectivity_service.dart';
import '../../utils/app_colors.dart';

/// Widget que verifica la conectividad y bloquea la app si no hay internet
class ConnectivityChecker extends StatefulWidget {
  final Widget child;

  const ConnectivityChecker({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ConnectivityChecker> createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  final ConnectivityService _connectivity = ConnectivityService();
  bool _isConnected = true;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    // Verificar conectividad inicial
    final connected = await _connectivity.checkConnectivity();
    
    if (mounted) {
      setState(() {
        _isConnected = connected;
        _isChecking = false;
      });
    }

    // Iniciar monitoreo periódico
    _connectivity.startMonitoring();
    
    // Escuchar cambios de conectividad
    _connectivity.addListener(_onConnectivityChanged);
  }

  void _onConnectivityChanged(bool isConnected) {
    if (mounted) {
      setState(() {
        _isConnected = isConnected;
      });
    }
  }

  Future<void> _retryConnection() async {
    setState(() {
      _isChecking = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    final connected = await _connectivity.checkConnectivity();

    if (mounted) {
      setState(() {
        _isConnected = connected;
        _isChecking = false;
      });
    }
  }

  @override
  void dispose() {
    _connectivity.removeListener(_onConnectivityChanged);
    _connectivity.stopMonitoring(); // Detener el Timer periódico
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar pantalla de carga mientras verifica
    if (_isChecking) {
      return _buildLoadingScreen();
    }

    // Si no hay conexión, mostrar pantalla de error
    if (!_isConnected) {
      return _buildNoConnectionScreen();
    }

    // Si hay conexión, mostrar la app normal
    return widget.child;
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/hector_logo.svg',
              height: 120,
              placeholderBuilder: (_) => Icon(
                Icons.sports_soccer,
                size: 120,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text(
              'Verificando conexión...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoConnectionScreen() {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icono de error
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.wifi_off,
                    size: 80,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 32),

                // Título
                const Text(
                  'Sin Conexión a Internet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Descripción
                Text(
                  'Football Impostor necesita conexión a internet para funcionar correctamente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Instrucciones
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.info_outline,
                            color: Colors.amber,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Por favor, verifica:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildCheckItem('WiFi o datos móviles activados'),
                      _buildCheckItem('Modo avión desactivado'),
                      _buildCheckItem('Señal de internet estable'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Botón de reintentar
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isChecking ? null : _retryConnection,
                    icon: _isChecking
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.refresh, size: 24),
                    label: Text(
                      _isChecking ? 'Verificando...' : 'Reintentar',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

