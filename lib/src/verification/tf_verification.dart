import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:thirdfactor/src/verification/tf_liveliness.dart';

class TfVerification extends StatefulWidget {
  const TfVerification({super.key});

  @override
  State<TfVerification> createState() => _TfVerificationState();
}

class _TfVerificationState extends State<TfVerification>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Animation duration of 5 seconds
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
        if (_animation.value == 1.0) {
          _startBlinking();
        }
      });

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Blinking duration of 3 seconds
    );

    _blinkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_blinkController)
      ..addListener(() {
        setState(() {});
      });


    _controller.forward();
  }
  void _startBlinking() {
    _blinkController.repeat(reverse: true);
    // Stop the blinking after 3 seconds
    Timer(const Duration(seconds: 5), () {
      _blinkController.stop();
    });
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();

    // Select the front camera
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    await _cameraController!.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _controller.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(onPressed: () {}, child: const Text("En")),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Face Verification",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff371b57)),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xff371b57),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: SizedBox(
                              width: 180,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipOval(
                                    child: AspectRatio(
                                      aspectRatio: 1.0, // To maintain a circular shape
                                      child: _isCameraInitialized
                                          ? CameraPreview(_cameraController!)
                                          : Container(
                                        color: Colors.black,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 185, // Set the desired width
                                    height: 185, // Set the desired height
                                    child: CircularProgressIndicator(
                                      strokeWidth: 8.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _animation.value < 1.0
                                            ? Colors.purple
                                            : Colors.purple.withOpacity(_blinkAnimation.value),
                                      ),
                                      value: _animation.value < 1.0
                                          ? _animation.value
                                          : 1.0, // Show the full circle when animation is complete
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
              _animation.value == 1.0 ?
              Container(
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.grey.shade600, borderRadius: BorderRadius.circular(5)),
                            child:  const Center(
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.red,
                                        child: Icon(Icons.close_rounded, size: 15, color: Colors.white,)),
                                    Flexible(
                                      child: Text(
                                         "Failed. Make sure your face is completely visible" ,
                                      
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ): Container(
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.grey.shade600, borderRadius: BorderRadius.circular(5)),
                            child:  const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                                                    "Perform live photo Verification",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(_animation.value == 1.0)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: TextButton(
                onPressed: () {
                  // Reset and restart the animation
                  _controller.reset();
                  _controller.forward();
                },
                child: Text(
                  "Retake".toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          if(_animation.value == 1.0)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TfLivelinessVerification()));
                    },
                    child: Text(
                      "Continue Anyway".toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ))),
          ),
        ],
      ),
    );
  }
}
