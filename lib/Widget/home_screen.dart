import 'package:flutter/material.dart';
import 'package:quick_app/Controller/note_provider.dart';
import '../Entitiy/Note.dart';
import 'add_note_screen.dart';
import 'view_note_screen.dart'; // ✅ Import this

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

  final colors = ['#FFE082', '#AED581', '#81D4FA', '#FFAB91', '#ffffff'];
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
                        hintText: 'Search notes...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon: Icon(Icons.search, color: primaryBlue),
                        suffixIcon: searchTerm.isNotEmpty
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
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
                  ElevatedButton(
                    onPressed: clearFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Clear', style: TextStyle(color: Colors.white)),
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
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      items: [null, ...colors].map((c) {
                        return DropdownMenuItem<String>(
                          value: c,
                          child: c == null
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
                      decoration: InputDecoration(
                        labelText: 'Sort by Date',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade200),
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
                child: notes.isEmpty
                    ? Center(child: Text('No notes found', style: TextStyle(fontSize: 18, color: Colors.grey[600])))
                    : ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (_, i) {
                          final note = notes[i];
                          return Card(
                            color: hexToColor(note.color).withOpacity(0.3),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(note.content),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => ViewNoteScreen(note: note)), // ✅
                                );
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
            await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddNoteScreen()));
            loadNotes();
          },
        ),
      ),
    );
  }
}
