
class Employee {
  int? id;
  String name;
  String jobRole;
  String startDate;
  String? endDate;

  Employee({
    this.id,
    required this.name,
    required this.jobRole,
    required this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'jobRole': jobRole,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      jobRole: map['jobRole'],
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }
}
