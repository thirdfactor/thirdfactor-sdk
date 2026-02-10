import 'dart:convert';
import 'package:example/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thirdfactor/thirdfactor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the Flutter application with ThirdFactorScope for e-KYC verification
    return ThirdFactorScope(
      clientId: "YOUR_CLIENT_ID",
      transitionBuilder: (_, animation, __, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      builder: (context, navKey) {
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
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? sessionUrl;
  TfResponse? tfResponse;
  bool loading = false;
  late final DioClient dioClient;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dioClient = DioClient();

    if (tfResponse != null) {
      sessionUrl == null;
      generateVerificationUrl();
    }
  }

  // Generates the e-KYC verification URL using DioClient
  Future<void> generateVerificationUrl() async {
    try {
      setState(() {
        loading = true;
      });

      final url = await dioClient.generateVerificationUrl(
          jwtToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
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
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    //This is for generating the verification url
                    generateVerificationUrl();


                    //This is for navigating to the url
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
                child: tfResponse!.documentPhotos != null
                    ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      tfResponse!.documentPhotos != null
                          ? ListView.builder(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tfResponse!.documentPhotos!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Image.memory(
                              base64Decode(
                                tfResponse!.documentPhotos![index].originalPhoto!,
                              ),
                              height: size.height * 0.4,
                            ),
                          );
                        },
                      )
                          : const SizedBox.shrink(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("nationality: ${tfResponse!.documentPhotos![0].nationality}"),
                          Text("documentNumber: ${tfResponse!.documentPhotos![0].documentNumber}"),
                        ],
                      )
                    ],
                  ),
                )
                    : const SizedBox.shrink(),
              )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.isLoading, required this.child});
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
          isLoading ? const Center(child: CircularProgressIndicator.adaptive()) : const SizedBox.shrink(),
        ]),
      ),
    );
  }
}
