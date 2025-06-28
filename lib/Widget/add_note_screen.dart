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

  final colors = {'#FFE082': 'Sunshine Yellow', '#AED581': 'Fresh Green', '#81D4FA': 'Sky Blue', '#FFAB91': 'Peach'};

  final primaryBlue = const Color(0xFF42A5F5);

  Future<void> saveNote() async {
    final note = Note(id: 0, title: titleCtrl.text, content: contentCtrl.text, color: colorHex, createdAt: '');
    await NoteProvider.addNote(note);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(children: const [Icon(Icons.check_circle, color: Colors.green), SizedBox(width: 8), Text('Note Added!')]),
            content: const Text('Your note has been saved successfully.'),
            actions: [TextButton(onPressed: () => Navigator.popUntil(context, (route) => route.isFirst), child: const Text('OK'))],
          ),
    );
  }

  Color hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF42A5F5), Color(0xFF1E88E5), Color(0xFF5C6BC0), Color(0xFF7E57C2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text('Add Note', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          centerTitle: true,
          elevation: 4,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: 'Title',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

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

            DropdownButtonFormField<String>(
              value: colorHex,
              decoration: InputDecoration(
                labelText: 'Note Color',
                prefixIcon: Icon(Icons.palette, color: Colors.blueAccent),
                
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
              ),
              style: TextStyle(color: Colors.black87, fontSize: 14),
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.blueAccent),
              items:
                  colors.entries.map((entry) {
                    final bool isSelected = colorHex == entry.key;

                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? hexToColor(entry.key).withOpacity(0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSelected ? [BoxShadow(color: Colors.grey.shade200, blurRadius: 4, spreadRadius: 1)] : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              margin: EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: hexToColor(entry.key),
                                shape: BoxShape.circle,
                                border: Border.all(color: isSelected ? Colors.blueAccent : Colors.grey.shade400, width: isSelected ? 2 : 1),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected ? Colors.blueAccent : Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: (val) => setState(() => colorHex = val!),
              menuMaxHeight: 300, // Limit dropdown height for better UX
              isExpanded: true, // Makes dropdown take full width
            ),

            const SizedBox(height: 20),

            // Preview
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: hexToColor(colorHex).withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Text('Preview: ${colors[colorHex]}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87)),
              ),
            ),

            const SizedBox(height: 30),

            // Save Button
            GestureDetector(
              onTap: saveNote,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF42A5F5),
                      Color(0xFF1E88E5),
                      Color(0xFF5C6BC0),
                      Color(0xFF7E57C2)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: const Center(
                  child: Text('Save Note', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}
