import '../database/database_helper.dart';
import '../models/notes.dart';

class NotesService {
  static Future<List<Note>> getAllNotes() async {
    return await DatabaseHelper.getAllNotes();
  }

  static Future<List<Note>> searchNotes(String query) async {
    if (query.isEmpty) {
      return await getAllNotes();
    }
    return await DatabaseHelper.searchNotes(query);
  }

  static Future<List<Note>> filterNotes(List<Note> notes, String searchQuery,
      String category) async {
    List<Note> filteredNotes = notes;

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filteredNotes = filteredNotes.where((note) {
        return note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            note.content.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Filter by category
    if (category != 'All') {
      filteredNotes = filteredNotes.where((note) {
        return note.category == category;
      }).toList();
    }

    return filteredNotes;
  }

  static Future<int> createNote(Note note) async {
    return await DatabaseHelper.insertNote(note);
  }

  static Future<int> updateNote(Note note) async {
    return await DatabaseHelper.updateNote(note);
  }

  static Future<int> deleteNote(int id) async {
    return await DatabaseHelper.deleteNote(id);
  }
}