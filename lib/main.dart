import 'package:flutter/material.dart';
import 'package:notes_app_flutter/models/note_database.dart';
import 'package:notes_app_flutter/pages/notes_page.dart';
import 'package:provider/provider.dart';

void main() async{

  //initialize isar note database
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();
  runApp(
    ChangeNotifierProvider(create: (context)=> NoteDatabase(),
    child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesPage(),
    );
  }
}
