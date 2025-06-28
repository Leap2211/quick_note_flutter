import 'package:flutter/material.dart';
import 'package:quick_app/Controller/note_provider.dart';
import '../Entitiy/Note.dart';
import 'add_note_screen.dart';
import 'view_note_screen.dart';
import '../Widget/Custom_Widgets/alert_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  String searchTerm = '';
  String? filterColor;
  String sortOrder = 'DESC';
  FocusNode searchFocusNode = FocusNode();

  final colors = ['#FFE082', '#AED581', '#81D4FA', '#FFAB91'];
  final primaryBlue = const Color(0xFF42A5F5);

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> loadNotes() async {
    final data = await NoteProvider.getNotes(search: searchTerm, color: filterColor, sort: sortOrder);
    setState(() => notes = data);
  }

  void _confirmDelete(BuildContext context, int noteId) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(children: const [Icon(Icons.warning_amber_rounded, color: Colors.red), SizedBox(width: 8), Text("Delete Note?")]),
            content: const Text("Are you sure you want to delete this note?"),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  delete(noteId);
                },
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  Future<void> delete(int id) async {
    await NoteProvider.deleteNote(id);
    loadNotes();
  }

  void clearFilters() {
    setState(() {
      searchTerm = '';
      filterColor = null;
      sortOrder = 'DESC';
    });
    loadNotes();
  }

  Color hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
          title: const Text('QuickNotes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          centerTitle: true,
          elevation: 4,
          backgroundColor: Colors.transparent,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              // Search Bar and Clear Button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: primaryBlue),
                      decoration: InputDecoration(
                        hintText: 'Search notes... ',
                        hintStyle: TextStyle(
                          foreground:
                              Paint()
                                ..shader = const LinearGradient(
                                  colors: [Color(0xFF42A5F5), Color(0xFF7E57C2)],
                                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                        ),
                        prefixIcon: Icon(Icons.search, color: primaryBlue),
                        suffixIcon:
                            searchTerm.isNotEmpty
                                ? IconButton(
                                  icon: Icon(Icons.clear, color: primaryBlue),
                                  onPressed: () {
                                    setState(() => searchTerm = '');
                                    loadNotes();
                                  },
                                )
                                : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade200)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: primaryBlue, width: 2),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() => searchTerm = val);
                        loadNotes();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: clearFilters,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF42A5F5), Color(0xFF1E88E5), Color(0xFF5C6BC0), Color(0xFF7E57C2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Text('Clear', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Filter and Sort Row
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: filterColor,
                      hint: Text('Filter by Color', style: TextStyle(color: primaryBlue)),
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade200)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: primaryBlue, width: 2),
                        ),
                      ),
                      items:
                          [null, ...colors].map((c) {
                            return DropdownMenuItem<String>(
                              value: c,
                              child:
                                  c == null
                                      ? const Text("All Colors")
                                      : Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: hexToColor(c),
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: Colors.black26),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(c),
                                        ],
                                      ),
                            );
                          }).toList(),
                      onChanged: (val) {
                        setState(() => filterColor = val);
                        loadNotes();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: sortOrder,
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Sort by Date',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade200)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: primaryBlue, width: 2),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'DESC', child: Text('Newest First')),
                        DropdownMenuItem(value: 'ASC', child: Text('Oldest First')),
                      ],
                      onChanged: (val) {
                        setState(() => sortOrder = val!);
                        loadNotes();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Note list
              Expanded(
                child:
                    notes.isEmpty
                        ? Center(child: Text('No notes found', style: TextStyle(fontSize: 18, color: Colors.grey[600])))
                        : ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (_, i) {
                            final note = notes[i];
                            final Color noteColor = hexToColor(note.color).withOpacity(0.3);

                            return Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                title: Row(
                                  children: [
                                    // Colored container
                                    Container(
                                      width: 40,
                                      height: 40,
                                      margin: const EdgeInsets.only(right: 16),
                                      decoration: BoxDecoration(color: noteColor, borderRadius: BorderRadius.circular(10)),
                                    ),

                                    // Note content
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                          const SizedBox(height: 4),
                                          Text(
                                            note.content,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Delete button
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.close, size: 18, color: Colors.red),
                                        onPressed: () => _confirmDelete(context, note.id),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => ViewNoteScreen(note: note)));
                                },
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF42A5F5), Color(0xFF1E88E5), Color(0xFF5C6BC0), Color(0xFF7E57C2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.5), offset: Offset(0, 3), blurRadius: 8)],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Add Note', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          onPressed: () async {
            final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddNoteScreen()));
            if (result == true) {
              CustomAlertDialog.showConfirmationDialog(
                context: context,
                title: 'Note Added ✅',
                content: 'Your note has been successfully saved.',
                onConfirmed: () {},
              );
            }
            loadNotes();
          },
        ),
      ),
    );
  }
}
