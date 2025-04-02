import 'package:e_cell_website/services/const/toaster.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/providers/certificate_provider.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';

class CertificateDialogs {
  static void showCertificateInputDialog(BuildContext context,
      {required String apiUrl}) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController identifierController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: secondaryColor, width: 1),
        ),
        child: Consumer<CertificateProvider>(
          builder: (context, provider, child) {
            return Container(
              padding: const EdgeInsets.all(20),
              constraints: const BoxConstraints(maxWidth: 600),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: eventBoxLinearGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LinearGradientText(
                      child: Text(
                        'Certificate',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Download your certificate by entering your details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        RadioListTile<String>(
                          title: const Text(
                            'Registration No.',
                            style: TextStyle(color: Colors.white),
                          ),
                          activeColor: const Color(0xFFD4AF37),
                          value: 'Registration Number',
                          groupValue: provider.identifierType,
                          onChanged: (value) {
                            provider.setIdentifierType(value!);
                            identifierController.clear();
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text(
                            'Email',
                            style: TextStyle(color: Colors.white),
                          ),
                          activeColor: const Color(0xFFD4AF37),
                          value: 'Email',
                          groupValue: provider.identifierType,
                          onChanged: (value) {
                            provider.setIdentifierType(value!);
                            identifierController.clear();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: identifierController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Enter your ${provider.identifierType}',
                        labelStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xFFD4AF37)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xFFD4AF37)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFD4AF37), width: 2),
                        ),
                        prefixIcon: Icon(
                          provider.identifierType == 'Email'
                              ? Icons.email
                              : Icons.badge,
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your ${provider.identifierType}';
                        }
                        if (provider.identifierType == 'Email' &&
                            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: provider.isLoading
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    Navigator.of(context).pop();
                                    _showResultDialog(context, apiUrl: apiUrl);
                                    try {
                                      await provider.fetchCertificate(
                                        identifier: identifierController.text,
                                        apiUrl: apiUrl,
                                      );
                                    } catch (e) {
                                      showCustomToast(
                                          title: "Error, Try Again",
                                          description: "An error occurred: $e");
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child: const Text('Get Certificate'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static void _showResultDialog(BuildContext context,
      {required String apiUrl}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Color(0xFFD4AF37), width: 1),
        ),
        child: Consumer<CertificateProvider>(
          builder: (context, provider, child) {
            return Container(
              padding: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxWidth: 600),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: eventBoxLinearGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
              child: provider.isLoading
                  ? const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LoadingIndicator(),
                        SizedBox(height: 20),
                        Text(
                          'Fetching your certificate...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.isSuccess) ...[
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFFD4AF37),
                            size: 50,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Congratulations ${provider.name}!',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            provider.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'A copy has been sent to ${provider.email}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton.icon(
                            icon: provider.isDownloading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.download),
                            label: Text(provider.isDownloading
                                ? 'Downloading...'
                                : 'Download Certificate'),
                            onPressed: provider.isDownloading
                                ? null
                                : () => provider.downloadCertificate(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4AF37),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              disabledBackgroundColor: Colors.grey[400],
                            ),
                          ),
                        ] else if (provider.errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Text(
                            'Please Check Your Details Once Again!...',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'No certificate associated with your provided details. Please check it once or contact E-Cell.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          const SelectableText(
                            'Contact: e-cell@vishnu.edu.in',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                provider.resetState();
                                showCertificateInputDialog(context,
                                    apiUrl: apiUrl);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Try Again'),
                            ),
                            const SizedBox(width: 15),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                provider.resetState();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: provider.isSuccess
                                    ? const Color(0xFFD4AF37)
                                    : Colors.grey[800],
                                foregroundColor: provider.isSuccess
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              child:
                                  Text(provider.isSuccess ? 'Done' : 'Close'),
                            ),
                          ],
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
