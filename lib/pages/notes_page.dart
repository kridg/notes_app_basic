import 'package:flutter/material.dart';
import 'package:notes_app_flutter/main.dart';
import 'package:notes_app_flutter/models/note_database.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  //text controller to access what the user typed
  final textController = TextEditingController();

  @override
  void initState(){
    super.initState();
//here on app startup we can fetch the existing notes
    readNotes();
  }

  //create a note
  void createNote(){
    showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          //create button
          MaterialButton(
              onPressed: (){
                //this adds the text to database
                context.read<NoteDatabase>().addNote(textController.text);

                //now to clear the controller
                textController.clear();
                //now to pop dialog box
                Navigator.pop(context);
          },
          child: const Text("Create"),)
        ],
      ),);
  }
  //read notes
  void readNotes(){
    context.read<NoteDatabase>().fetchNotes();
  }

  //update a note
  void updateNote(Note note){
    //prefill the current note text
    textController.text=note.text;
    showDialog(
        context: context,
        builder: (context)=> AlertDialog(
          title: Text("Update Note"),
          content: TextField(controller: textController,),
          actions: [
            //update button
            MaterialButton(onPressed: (){
              //update note in db
              context.read<NoteDatabase>().updateNote(note.id, textController.text);
              //now again clear the controller
              textController.clear();
              //now pop
              Navigator.pop(context);
            },
            child: const Text("Update"),
            )
          ],
        ),
    );
  }
  //delete a note
  void deleteNote(int id){
    context.read<NoteDatabase>().deleteNote(id);
  }
  @override
  Widget build(BuildContext context) {

    //note database
    final noteDatabase=context.watch<NoteDatabase>();

    //current notes
    List<Note> currentNotes =noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(title: Text('Notes'),),
      floatingActionButton: FloatingActionButton(
          onPressed: createNote,
      child: const Icon(Icons.add),),
      body: ListView.builder(
        itemCount: currentNotes.length,
          itemBuilder: (context, index){
        //get individual note
        final note= currentNotes[index];
        //list tile UI
        return ListTile(
          title: Text(note.text),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              //edit button
              IconButton(
                  onPressed: ()=>updateNote(note),
                  icon: const Icon(Icons.edit),
              ),
              //delete button
              IconButton(
                onPressed: ()=>deleteNote(note.id),
                icon: const Icon(Icons.delete),
              ),
          ],),
        );
      }),
    );
  }
}
