
import 'package:flutter/material.dart';

class CustomSnackbar {
  static showCustomSnackbar({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: Colors.green,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "DISMISS",
          textColor: Colors.green,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
