import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart'; 

class QRScannerScreen extends StatefulWidget {
  final int? multiScanCount;
  const QRScannerScreen({super.key, this.multiScanCount});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}


class _QRScannerScreenState extends State<QRScannerScreen> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool _isPaused = false;
  final List<String> _scannedCodes = [];
  late MobileScannerController cameraController;
  bool isTorchOn = false;
  bool isPermissionGranted = false;


  bool _showGreenOverlay = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeController();
    _checkPermission();


    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  void _initializeController() {
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      autoStart: false,
    );
  }


  void _triggerSuccessEffects() async {

    HapticFeedback.heavyImpact(); 
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 100); 
    }


    setState(() => _showGreenOverlay = true);
    await Future.delayed(const Duration(milliseconds: 150));
    if (mounted) setState(() => _showGreenOverlay = false);
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() => isPermissionGranted = true);
      cameraController.start();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose(); 
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [

          Positioned.fill(
            child: isPermissionGranted
                ? MobileScanner(
              controller: cameraController,
              onDetect: (capture) async {
                if (_isPaused) return;
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? code = barcodes.first.rawValue;
                  if (code != null && !_scannedCodes.contains(code)) {


                    _triggerSuccessEffects();

                    setState(() {
                      _isPaused = true;
                      _scannedCodes.add(code);
                    });

                    if (widget.multiScanCount == null) {
                      Navigator.pop(context, code);
                      return;
                    }

                    if (_scannedCodes.length >= widget.multiScanCount!) {
                      Navigator.pop(context, _scannedCodes);
                      return;
                    }

                    await Future.delayed(const Duration(seconds: 1));
                    if (mounted) setState(() => _isPaused = false);
                  }
                }
              },
            )
                : Container(color: Colors.black),
          ),


          if (_showGreenOverlay)
            Positioned.fill(
              child: Container(
                color: Colors.green.withOpacity(0.4),
              ),
            ),


          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: ScannerOverlayPainter(
                  borderColor: const Color(0xFF8B5CF6),
                  borderRadius: 30,
                  animationValue: _animationController, 
                ),
              ),
            ),
          ),


          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            widget.multiScanCount == null
                ? "Scan QR Code"
                : "Scanned: ${_scannedCodes.length}/${widget.multiScanCount}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 10, color: Colors.black)],
            ),
          ),
          IconButton(
            icon: Icon(isTorchOn ? Icons.flashlight_on : Icons.flashlight_off, color: Colors.white),
            onPressed: () async {
              await cameraController.toggleTorch();
              setState(() => isTorchOn = !isTorchOn);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black54,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => Navigator.pop(context),
        child: Text(
          widget.multiScanCount == null ? "Cancel" : "Finish Early (${_scannedCodes.length})",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderRadius;
  final Animation<double> animationValue; 

  ScannerOverlayPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.animationValue,
  }) : super(repaint: animationValue); 

  @override
  void paint(Canvas canvas, Size size) {
    const double scanSize = 280.0;
    final double left = (size.width - scanSize) / 2;
    final double top = (size.height - scanSize) / 2;


    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    const double len = 40;
    canvas.drawPath(Path()..moveTo(left, top + len)..lineTo(left, top)..lineTo(left + len, top), borderPaint);
    canvas.drawPath(Path()..moveTo(left + scanSize - len, top)..lineTo(left + scanSize, top)..lineTo(left + scanSize, top + len), borderPaint);
    canvas.drawPath(Path()..moveTo(left, top + scanSize - len)..lineTo(left, top + scanSize)..lineTo(left + len, top + scanSize), borderPaint);
    canvas.drawPath(Path()..moveTo(left + scanSize - len, top + scanSize)..lineTo(left + scanSize, top + scanSize)..lineTo(left + scanSize, top + scanSize - len), borderPaint);


    final linePaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2.0
      ..shader = LinearGradient(
        colors: [
          Colors.greenAccent.withOpacity(0.0),
          Colors.greenAccent,
          Colors.greenAccent.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(left, top, scanSize, 2));


    final double currentLineTop = top + (scanSize * animationValue.value);

    canvas.drawLine(
      Offset(left, currentLineTop),
      Offset(left + scanSize, currentLineTop),
      linePaint..strokeWidth = 3,
    );


    final shadowPaint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);

    canvas.drawRect(
      Rect.fromLTWH(left, currentLineTop - 2, scanSize, 4),
      shadowPaint,
    );
  }

  @override
  bool shouldRepaint(ScannerOverlayPainter oldDelegate) => true;
}
