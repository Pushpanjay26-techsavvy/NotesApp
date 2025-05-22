import 'package:flutter/material.dart';
import '../models/notes.dart';
import '../services/notes_service.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_filter.dart';
import '../widgets/notes_card.dart';
import '../utils/constants.dart';
import 'notes_detail_page.dart';

class NotesHomePage extends StatefulWidget {
  @override
  _NotesHomePageState createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final loadedNotes = await NotesService.getAllNotes();
    setState(() {
      notes = loadedNotes;
      filteredNotes = loadedNotes;
    });
  }

  Future<void> _filterNotes() async {
    final filtered = await NotesService.filterNotes(
      notes,
      searchController.text,
      selectedCategory,
    );
    setState(() {
      filteredNotes = filtered;
    });
  }

  void _onCategoryChanged(String? newCategory) {
    setState(() {
      selectedCategory = newCategory ?? 'All';
    });
    _filterNotes();
  }

  Future<void> _deleteNote(int id) async {
    await NotesService.deleteNote(id);
    _loadNotes();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.noteDeleted)),
    );
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.deleteConfirmTitle),
        content: Text(AppStrings.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              _deleteNote(id);
              Navigator.pop(context);
            },
            child: Text(
              AppStrings.delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToNoteDetail([Note? note]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(note: note),
      ),
    );
    if (result == true) {
      _loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appTitle),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SearchBarWidget(
                  controller: searchController,
                  onChanged: (value) => _filterNotes(),
                ),
                SizedBox(height: 12),
                CategoryFilter(
                  selectedCategory: selectedCategory,
                  onChanged: _onCategoryChanged,
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    AppStrings.noNotesFound,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  if (searchController.text.isNotEmpty || selectedCategory != 'All')
                    Text(
                      AppStrings.adjustSearchFilter,
                      style: TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                return NoteCard(
                  note: note,
                  onTap: () => _navigateToNoteDetail(note),
                  onEdit: () => _navigateToNoteDetail(note),
                  onDelete: () => _showDeleteDialog(note.id!),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToNoteDetail(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
    );
  }
}