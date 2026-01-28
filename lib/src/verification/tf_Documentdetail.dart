
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../utils/tf_customDropdown.dart';

class TfDocumentDetail extends StatefulWidget {
  const TfDocumentDetail({super.key});

  @override
  State<TfDocumentDetail> createState() => _TfDocumentDetailState();
}

class _TfDocumentDetailState extends State<TfDocumentDetail> {
  String selectedValue = 'Citizenship';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLanguageButton(),
            _buildTitleSection(),
            _buildStepIndicator(),
            _buildDropdowns(),
            const SizedBox(height: 12),
            if (selectedValue == "Citizenship") _buildCitizenshipForm(),
            if (selectedValue == "Driver's License") _buildForm(),
            if (selectedValue == "Voter ID") _buildForm(),
            if (selectedValue == "Passport") _buildCitizenshipForm(),
            if (selectedValue == "PAN Card") _buildForm(),
            if (selectedValue == "National ID") _buildForm(),
            if (selectedValue == "Disability Card") _buildForm(),
            const SizedBox(height: 20),
            // _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton() {
    return TextButton(
      onPressed: () {},
      child: const Text("En"),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "KYC".toUpperCase(),
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xff371b57),
            ),
          ),
          const SizedBox(height: 4),
          const Text("Enter personal information"),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStep(isCompleted: true),
              Expanded(child: _buildLine(isActive: true)),
              _buildStep(isCompleted: true),
              Expanded(child: _buildLine(isActive: false)),
              _buildStep(isCompleted: false),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "PERSONAL\nDETAILS",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "LIVELINESS\nVERIFICATION",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "DOCUMENT\nDETAILS",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdowns() {
    return Column(
      children: [
        const CustomDropdown(
          labelText: 'Select Nationality',
          value: 'Nepali',
          items: ['Nepali', 'foreign'],
        ),
        const SizedBox(height: 20),
        CustomDropdown(
          labelText: 'Choose Document Type',
          value: selectedValue,
          items: const [
            'Citizenship',
            'Driver\'s License',
            'Voter ID',
            'Passport',
            'PAN Card',
            'National ID',
            'Disability Card',
          ],
          onChanged: (newValue) {
            setState(() {
              selectedValue = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCitizenshipForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: '$selectedValue Number',
              enabledBorder: _buildBorder(Colors.purple.withOpacity(0.5)),
              focusedBorder: _buildBorder(Colors.purple.withOpacity(0.5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
          const SizedBox(height: 20),
          _buildUploadSection('$selectedValue Front Page'),
          const SizedBox(height: 20),
          _buildUploadSection('$selectedValue Back Page'),
        ],
      ),
    );
  }
  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: '$selectedValue Number',
              enabledBorder: _buildBorder(Colors.purple.withOpacity(0.5)),
              focusedBorder: _buildBorder(Colors.purple.withOpacity(0.5)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
          const SizedBox(height: 20),
          _buildUploadSection(selectedValue),

        ],
      ),
    );
  }

  // Widget _buildSubmitButton() {
  //   return Center(
  //     child: ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: const Color(0xff371b57),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(2.0),
  //         ),
  //         padding: const EdgeInsets.all(8.0),
  //       ),
  //       onPressed: () {},
  //       child: Text(
  //         "I am ready, Let's Go".toUpperCase(),
  //         style: const TextStyle(
  //           fontWeight: FontWeight.bold,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: color),
    );
  }

  Widget _buildStep({required bool isCompleted}) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: isCompleted ? Colors.green : Colors.white,
      child: Icon(
        isCompleted ? Icons.check : Icons.circle_outlined,
        color: isCompleted ? Colors.white : Colors.green,
      ),
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Container(
      height: 2,
      color: isActive ? Colors.green : Colors.grey,
    );
  }

  Widget _buildUploadSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_circle_outline,
                  size: 40,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                Text(
                  'Upload $title Photo',
                  style: const TextStyle(color: Colors.grey),
                ),
                const Text(
                  '.JPG .PNG .GIF',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
