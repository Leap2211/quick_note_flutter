import 'package:flutter/material.dart';
import 'package:quick_app/Controller/note_provider.dart';
import 'package:quick_app/Entitiy/Note.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  String colorHex = '#FFE082';

  final colors = {
    '#FFE082': 'Sunshine Yellow',
    '#AED581': 'Fresh Green',
    '#81D4FA': 'Sky Blue',
    '#FFAB91': 'Peach',
  };

  final primaryBlue = const Color(0xFF42A5F5);

  Future<void> saveNote() async {
    final note = Note(
      id: 0,
      title: titleCtrl.text,
      content: contentCtrl.text,
      color: colorHex,
      createdAt: '',
    );
    await NoteProvider.addNote(note);
    Navigator.pop(context);
  }

  Color hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
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
          title: const Text('QuickNotes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.2)),
          centerTitle: true,
          elevation: 4,
          backgroundColor: Colors.transparent,
        )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title Field
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: 'Title',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // Content Field
            TextField(
              controller: contentCtrl,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Content',
                prefixIcon: const Icon(Icons.notes),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // Color Dropdown
            DropdownButtonFormField<String>(
              value: colorHex,
              decoration: InputDecoration(
                labelText: 'Note Color',
                prefixIcon: const Icon(Icons.palette),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: colors.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: hexToColor(entry.key),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                      Text(entry.value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) => setState(() => colorHex = val!),
            ),

            const SizedBox(height: 30),

            // Gradient Save Button
            GestureDetector(
              onTap: saveNote,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Save Note',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
