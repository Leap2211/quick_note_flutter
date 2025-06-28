import 'package:flutter/material.dart';

class CustomAlertDialog {
  static Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirmed,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent tap outside to close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Text(content),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Confirm', style: TextStyle(color: Color(0xFF1E88E5), fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                onConfirmed(); // Trigger action
              },
            ),
          ],
        );
      },
    );
  }
}
