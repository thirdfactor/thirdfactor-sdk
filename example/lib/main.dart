// Import Dart's convert library for encoding and decoding data
import 'dart:convert';

// Import Flutter libraries and packages
import 'package:example/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thirdfactor/thirdfactor.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the Flutter application with ThirdFactorScope
    return ThirdFactorScope(
      // clientId: "YOUR_CLIENT_ID", // Replace with your client ID
      transitionBuilder: (_, animation, __, child) {
        // Define a custom transition animation for page navigation
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      builder: (context, navKey) {
        // Build the MaterialApp with ThirdFactorScope
        return MaterialApp(
          navigatorKey: navKey,
          title: 'TingTing',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(115, 62, 151, 1),
              primary: const Color.fromRGBO(115, 62, 151, 1),
            ),
            useMaterial3: true,
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          home: const MyHomePage(), // Set the initial page as MyHomePage
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? sessionUrl;
  TfResponse? tfResponse;
  bool loading = false;
  late final DioClient dioClient;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    dioClient = DioClient(); // Initialize DioClient for network requests
    generateVerificationUrl(); // Generate initial verification URL
    _initializeCamera();
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

  Future<void> generateVerificationUrl() async {
    try {
      setState(() {
        loading = true;
      });

      // Make a network request to generate a verification URL
      final url = await dioClient.generateVerificationUrl(
        jwtToken:
            "YOUR_JWT_TOKEN", // Replace with your JWT token
      );

      if (url != null) {
        setState(() {
          sessionUrl = url;
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: LoadingWidget(
        isLoading: loading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: 180,
                    height: 270,
                    child: _isCameraInitialized
                        ? Stack(
                          children: [
                            CameraPreview(_cameraController!),
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcOut,
                      ), // This one will create the magic
                      child: Stack(
                        // fit: StackFit.,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              backgroundBlendMode: BlendMode.dstOut,
                            ), // This one will handle background + difference out
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 180,
                              width: 180,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width / 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                          ],
                    )

                        : Container(
                            color: Colors.black,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: size.height * 0.1),
                Image.asset(
                  "assets/images/ting.png",
                  width: size.width * 0.5,
                ),
                const SizedBox(height: 32),
                Card(
                  child: ListTile(
                    title: Text(
                      "e-KYC Verification",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      "To access the XYZ feature, we'll need you to perform an e-KYC verification step. Note that this data will be used to create your customer profile on TingTing.",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      if (sessionUrl == null) return;

                      // Start ThirdFactor verification
                      await ThirdFactorScope.of(context).startVerification(
                        verificationUrl: sessionUrl!,
                        onCompletion: (val) {
                          setState(() {
                            tfResponse = val;
                          });
                        },
                        onboardingOptions: TfOnboardingOptions(
                          onboardingPages: List.generate(
                            4,
                            (index) => Image.asset(
                              'assets/images/11-0${index + 1}.png',
                              height: size.height,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                          showSkip: false,
                          showNext: false,
                          done: const Text("Start"),
                          dotsDecorator: TfDotsDecorator(
                            size: const Size.square(9.0),
                            activeColor: Colors.black,
                            color: Colors.grey.shade300,
                            activeSize: const Size(18.0, 9.0),
                            activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chevron_right),
                    label: const Text("Proceed to Verify"),
                  ),
                ),
                const SizedBox(height: 16),
                tfResponse != null
                    ? Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              tfResponse!.imageBytes != null
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Image.memory(
                                        base64Decode(tfResponse!.imageBytes!
                                            .split(',')
                                            .last),
                                        height: size.height * 0.4,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("status: ${tfResponse!.status}"),
                                  Text.rich(
                                    TextSpan(text: "message: ", children: [
                                      TextSpan(
                                        text: tfResponse!.message,
                                        style: TextStyle(
                                          color: tfResponse!.status
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ]),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget(
      {super.key, required this.isLoading, required this.child});

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: Opacity(
        opacity: isLoading ? 0.5 : 1,
        child: Stack(children: [
          child,
          isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : const SizedBox.shrink(),
        ]),
      ),
    );
  }
}
