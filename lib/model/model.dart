class StudentModel {
  int? id;
  final dynamic rollno;
  final String name;
  final String department;
  final dynamic phoneno;
  final dynamic age;
  final String? imageurl;

  StudentModel(
      {this.id,
      required this.rollno,
      required this.name,
      required this.department,
      required this.phoneno,
      this.imageurl,
      required this.age});

  static StudentModel fromMap(Map<String, Object?> map) {
    final id = map['id'] as int;
    final name = map['name'] as String;
    final rollno = map['rollno'] as int;
    final department = map['department'] as String;
    final age = map['age'] as int;
    final phoneno = map['phoneno'].toString();
    final imageurl = map["imageurl"] as String;

    return StudentModel(
      id: id,
      rollno: rollno,
      name: name,
      department: department,
      phoneno: phoneno,
      age: age,
      imageurl: imageurl,
    );
  }
}
