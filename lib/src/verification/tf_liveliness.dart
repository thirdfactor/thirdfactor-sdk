import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:thirdfactor/src/verification/tf_Documentdetail.dart';

class TfLivelinessVerification extends StatefulWidget {
  const TfLivelinessVerification({super.key});

  @override
  State<TfLivelinessVerification> createState() =>
      _TfLivelinessVerificationState();
}

class _TfLivelinessVerificationState extends State<TfLivelinessVerification>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  late bool _isReady = false;

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

    _blinkAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_blinkController)
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
      _isReady = false;
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
            padding: EdgeInsets.only(top: 8.0, left: 8),
            child: Text(
              "Liveliness Verification",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff371b57)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0, left: 8),
            child: Text(
              "Perform Live Photo Verification",
              style: TextStyle(),
            ),
          ),
          Container(
            color: const Color(0xff371b57),
            width: double.infinity,
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _isReady == true
                  ? Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1.0,
                          child: _isCameraInitialized
                              ? CameraPreview(_cameraController!)
                              : Container(
                                  color: Colors.black,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                        ),
                        LinearProgressIndicator(
                          // strokeWidth: 8.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _animation.value < 1.0
                                ? Colors.purple
                                : Colors.purple
                                    .withOpacity(_blinkAnimation.value),
                          ),
                          value: _animation.value < 1.0
                              ? _animation.value
                              : 1.0, // Show the full circle when animation is complete
                        )
                      ],
                    )
                  : Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                "You will be asked to perform a gesture in the next step.",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ))),
                    ),
            ),
          ),
          if (_isReady == false )
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(const Color(0xff371b57)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                2.0), // Adjust the radius as needed
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isReady = true;
                          _controller.reset();
                          _controller.forward();
                        });

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "I am ready, Let's Go".toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ))),
            ),
          if (_animation.value == 1.0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    // Reset and restart the animation
                    _controller.reset();
                    _controller.forward();
                    _isReady = true;
                  },
                  child: Text(
                    "Retake".toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          if (_animation.value == 1.0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TfDocumentDetail()));
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
