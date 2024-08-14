import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'notes';

  Future<void> insert({required Note note}) async {
    try {
      final docRef = _firestore.collection(_collectionName).doc();
      await docRef.set({
        'title': note.title,
        'description': note.description,
        'createdAt': Timestamp.fromDate(note.createdAt), // Use Firestore Timestamp
      });
    } catch (e) {
      print('Error inserting note: $e'); // Consider using a logging framework instead
    }
  }

  // Stream to listen to real-time updates
  Stream<List<Note>> getNotesStream() {
    return _firestore.collection(_collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
    }).handleError((e) {
      print('Error fetching notes: $e'); // Consider using a logging framework instead
    });
  }

  Future<List<Note>> getNotes() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionName).get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Note(
          id: doc.id, // Use Firestore document ID
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          createdAt: (data['createdAt'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
        );
      }).toList();
    } catch (e) {
      print('Error fetching notes: $e'); // Consider using a logging framework instead
      return []; // Return an empty list on error
    }
  }

  Future<void> update({required Note note}) async {
    try {
      await _firestore.collection(_collectionName).doc(note.id).update({
        'title': note.title,
        'description': note.description,
        'createdAt': Timestamp.fromDate(note.createdAt), // Use Firestore Timestamp
      });
    } catch (e) {
      print('Error updating note: $e'); // Consider using a logging framework instead
    }
  }

  Future<void> delete({required Note note}) async {
    try {
      await _firestore.collection(_collectionName).doc(note.id).delete();
    } catch (e) {
      print('Error deleting note: $e'); // Consider using a logging framework instead
    }
  }
}
