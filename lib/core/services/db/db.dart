
import 'package:infinity_notes/core/services/db/objectbox.dart';

class Database {
  Database._();

  static final Database _instance = Database._();

  factory Database() => _instance;

  late ObjectBoxStore instance;

  init() async {
    instance = await ObjectBoxStore.create();
  }
}