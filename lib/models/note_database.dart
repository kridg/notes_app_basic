import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:notes_app_flutter/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier{
  static late Isar isar;
  //INITIALIZE DATABASE
static Future<void>initialize() async{
  final dir=await getApplicationDocumentsDirectory();
  isar= await Isar.open(
      [NoteSchema],
      directory: dir.path,);
}
//list of notes
final List<Note> currentNotes=[];
  //CREATE -a note and save to db
  Future<void>addNote(String textFromUser) async{
    final newNote=Note()..text=textFromUser;

    await isar.writeTxn(()=>isar.notes.put(newNote));

    //re-read from database
    fetchNotes();

  }
  //READ -notes from db
  Future<void> fetchNotes()async{
    List<Note> fetchedNotes= await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }
  //UPDATE -a note in db
  Future<void> updateNote(int id, String newText)async{
    final existingNote=await isar.notes.get(id);
    if(existingNote!=null){
      existingNote.text=newText;
      await isar.writeTxn(()=>isar.notes.put(existingNote));
      await fetchNotes();
    }
  }
  //DELETE -a note from the db
Future<void> deleteNote(int id) async{
    await isar.writeTxn(()=>isar.notes.delete(id));
    await fetchNotes();
}
}