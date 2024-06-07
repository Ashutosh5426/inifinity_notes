import 'package:uuid/uuid.dart';

class UniqueId {
  static const Uuid _uuid = Uuid();

  // Generates a v1 (time-based) UUID
  static String generateV1() {
    return _uuid.v1();
  }

  // Generates a v4 (random) UUID
  static String generateV4() {
    return _uuid.v4();
  }

  // Generates a v5 (namespace-based) UUID
  static String generateV5(String namespace, String name) {
    return _uuid.v5(Uuid.NAMESPACE_URL, name);
  }

// Add other UUID generation methods or variants as needed
}