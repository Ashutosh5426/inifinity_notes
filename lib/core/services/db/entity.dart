import 'package:objectbox/objectbox.dart';

@Entity()
class Person {
  int id = 0; // ObjectBox manages this property for you.
  String name;
  int age;
  String personId;

  Person({
    required this.personId,
    required this.name,
    required this.age,
  });
}
