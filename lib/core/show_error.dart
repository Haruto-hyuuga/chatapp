import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showErrorPopup({
  required BuildContext context,
  required String errorName,
  required String errorText,
  String errorType = "Runtime Error",
  IconData errorIcon = Icons.error_outline,
  Color errorColor = Colors.redAccent,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (_) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Material(
            color: Colors.transparent,
            child: ErrorPopupContent(
              errorName: errorName,
              errorText: errorText,
              errorType: errorType,
              errorIcon: errorIcon,
              errorColor: errorColor,
            ),
          ),
        ),
      );
    },
  );
}

class ErrorPopupContent extends StatelessWidget {
  final String errorName;
  final String errorText;
  final String errorType;
  final IconData errorIcon;
  final Color errorColor;

  const ErrorPopupContent({
    super.key,
    required this.errorName,
    required this.errorText,
    required this.errorType,
    required this.errorIcon,
    required this.errorColor,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 12)],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              Row(
                children: [
                  Icon(errorIcon, color: errorColor, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      errorName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: errorColor.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  errorType,
                  style: TextStyle(
                    color: errorColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text(
                  errorText,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Close",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final uri = Uri.parse(
                          "https://github.com/Haruto-hyuuga/chatapp",
                        );
                        launchUrl(uri, mode: LaunchMode.externalApplication);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: errorColor,
                        backgroundColor: const Color(0xFF121212),
                        side: BorderSide(color: errorColor, width: 2),
                      ),
                      child: const Text(
                        "Report Issue",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
