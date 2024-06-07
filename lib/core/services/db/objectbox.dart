import 'package:infinity_notes/core/services/db/entity.dart';
import 'package:infinity_notes/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBoxStore {
  late final Store _store;
  late final Box<Person> _personBox;

  ObjectBoxStore._init(this._store) {
    _personBox = Box<Person>(_store);
  }

  static Future<ObjectBoxStore> create() async {
    // Get the directory where ObjectBox can store its data.
    final directory = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: directory.path);
    return ObjectBoxStore._init(store);
  }

  // CRUD operations:

  int addPerson(Person person) {
    return _personBox.put(person);
  }

  Person? getPerson(int id) {
    return _personBox.get(id);
  }

  List<Person> getAllPeople() {
    return _personBox.getAll();
  }

  void removePerson(int id) {
    _personBox.remove(id);
  }

  // Remember to close the store when not needed anymore
  void close() {
    _store.close();
  }
}