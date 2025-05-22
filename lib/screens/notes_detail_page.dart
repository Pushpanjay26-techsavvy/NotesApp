import 'package:flutter/material.dart';
import '../models/notes.dart';
import '../services/notes_service.dart';
import '../utils/constants.dart';

class NoteDetailPage extends StatefulWidget {
  final Note? note;

  NoteDetailPage({this.note});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'Personal';

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedCategory = widget.note!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.titleRequired)),
      );
      return;
    }

    final now = DateTime.now();
    final note = Note(
      id: isEditing ? widget.note!.id : null,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      category: _selectedCategory,
      createdAt: isEditing ? widget.note!.createdAt : now,
      updatedAt: now,
    );

    if (isEditing) {
      await NotesService.updateNote(note);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.noteUpdated)),
      );
    } else {
      await NotesService.createNote(note);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.noteCreated)),
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? AppStrings.editNote : AppStrings.newNote),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: Text(
              AppStrings.save,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: AppStrings.titleLabel,
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  AppStrings.categoryLabel,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                    items: AppConstants.categoriesWithoutAll.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: AppStrings.contentLabel,
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }
}