import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_app/Entitiy/Note.dart';

class NoteProvider {
  static const String host = '10.100.100.161'; //constantly change base on ip
  static const int port = 3000;
  static const String baseUrl = 'http://$host:$port';

  static Future<List<Note>> getNotes({String? search, String? color, String? sort}) async {
    final queryParameters = <String, String>{};
    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }
    ;
    if (color != null && color.isNotEmpty) {
      queryParameters['color'] = color;
    }
    ;
    if (sort != null && (sort == 'ASC' || sort == 'DESC')) {
      queryParameters['sort'] = sort;
    }
    ;

    final uri = Uri(scheme: 'http', host: host, port: port, path: '/notes', queryParameters: queryParameters);

    final res = await http.get(uri);

    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((e) => Note.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  static Future<void> addNote(Note note) async {
    final res = await http.post(Uri.parse('$baseUrl/notes'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(note.toJson()));

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Failed to add note');
    }
  }

  static Future<void> deleteNote(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/notes/$id'));

    if (res.statusCode != 200) {
      throw Exception('Failed to delete note');
    }
  }
}
