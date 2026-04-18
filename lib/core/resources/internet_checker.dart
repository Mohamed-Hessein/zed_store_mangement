import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@singleton
class InternetConnectivity {
  InternetConnectivity();

  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  bool _isConnected = true;
  bool get isConnected => _isConnected;
  Stream<bool> get connectionStream => _connectionStatusController.stream;

  void initialize() {
    _checkInitialConnection();
    Connectivity().onConnectivityChanged.listen((results) {
      _updateConnectionStatus(results);
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    _isConnected = !results.contains(ConnectivityResult.none);
    _connectionStatusController.add(_isConnected);
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
