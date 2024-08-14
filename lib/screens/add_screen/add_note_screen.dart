import 'package:flutter/material.dart';
import 'package:my_diary/db/note_database.dart'; // Update import to NoteService
import 'package:my_diary/models/note.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final NoteService _noteService = NoteService(); // Use NoteService instance

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _title.text = widget.note!.title;
      _description.text = widget.note!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        actions: [
          if (widget.note != null)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: const Text('Delete note?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteNote();
                        },
                        child: const Text('Yes'),
                      )
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_outline),
            ),
          IconButton(
            onPressed: widget.note == null ? _insertNote : _updateNote,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: TextField(
                controller: _description,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _insertNote() async {
    final note = Note(
      title: _title.text,
      description: _description.text,
      createdAt: DateTime.now(),
    );
    await _noteService.insert(note: note);
    Navigator.pop(context); // Close the screen after saving
  }

  Future<void> _updateNote() async {
    final note = Note(
      id: widget.note!.id!,
      title: _title.text,
      description: _description.text,
      createdAt: widget.note!.createdAt,
    );
    await _noteService.update(note: note);
    Navigator.pop(context); // Close the screen after updating
  }

  Future<void> _deleteNote() async {
    if (widget.note != null) {
      await _noteService.delete(note: widget.note!);
      Navigator.pop(context); // Close the screen after deleting
    }
  }
}
