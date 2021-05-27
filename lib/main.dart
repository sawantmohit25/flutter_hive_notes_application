import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/adapters/notes_adapter.dart';
import 'package:notes_app/pages/display_notes_list.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(NotesAdapter());
  await Hive.openBox<Notes>('notes');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home:DisplayNotesList(),
    );
  }
}
