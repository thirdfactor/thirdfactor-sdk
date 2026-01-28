import 'package:flutter/material.dart';
import 'package:thirdfactor/src/verification/tf_verification.dart';

class TfStartVerification extends StatefulWidget {
  const TfStartVerification({super.key});

  @override
  State<TfStartVerification> createState() => _TfStartVerificationState();
}

class _TfStartVerificationState extends State<TfStartVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("packages/thirdfactor/lib/assets/images/image.png"),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(const Color(0xff371b57)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              2.0), // Adjust the radius as needed
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TfVerification()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Start Verification".toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ))),
          ),
        ],
      ),
    );
  }
}
