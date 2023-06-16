class Cat {

  final int id;
  final String url;
  final DateTime dateAdded;

  const Cat({
    required this.id,
    required this.url,
    required this.dateAdded,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'dateAdded': dateAdded,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $url, age: $dateAdded}';
  }

}