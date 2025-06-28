import 'package:flutter/material.dart';
import '../Entitiy/Note.dart';
import 'package:intl/intl.dart';

class ViewNoteScreen extends StatelessWidget {
  final Note note;

  const ViewNoteScreen({super.key, required this.note});

  Color hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = hexToColor(note.color);
    final Color cardColor = Colors.white;

    String formattedDate;
    if (note.createdAt.isNotEmpty) {
      try {
        // Assuming createdAt is in ISO 8601 format from the server
        final dateTime = DateTime.parse(note.createdAt).toLocal();
        formattedDate = DateFormat('MMMM d, yyyy ・ h:mm a').format(dateTime);
      } catch (e) {
        formattedDate = note.createdAt; // Fallback if parsing fails
      }
    } else {
      formattedDate = 'Not available';
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF42A5F5), // Light Blue
                  Color(0xFF1E88E5), // Medium Blue
                  Color(0xFF5C6BC0), // Indigo
                  Color(0xFF7E57C2), // Purple
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text("View Note", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: cardColor,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          shadowColor: Colors.black.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(note.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5))),
                const SizedBox(height: 12),

                // Divider
                Container(height: 2, width: 50, color: hexToColor(note.color).withOpacity(0.6)),
                const SizedBox(height: 16),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(note.content, style: const TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF333333))),
                  ),
                ),

                const SizedBox(height: 20),

                // Timestamp
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text("Created: $formattedDate", style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
