import 'package:flutter/material.dart';
import 'package:infinity_notes/core/services/db/db.dart';
import 'package:infinity_notes/core/services/db/objectbox.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late ObjectBoxStore db;

  @override
  void initState() {
    db = Database().instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Builder(
        builder: (context) {
          var people = db.getAllPeople();
          return ListView.builder(
            itemCount: people.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(people[index].name)),
                    IconButton(onPressed: (){
                      db.removePerson(people[index].id);
                      setState(() {});
                    }, icon: const Icon(Icons.delete, size: 30)),
                  ],
                ),
              );
            }
          );
        }
      ),
    );
  }
}
