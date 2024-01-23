// Assuming Employee class has an 'id' field
class Employee {
  int? id; // Add this field if not already present
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

  // Other methods and constructors...

  // Convert Employee object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'jobRole': jobRole,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  // Create an Employee object from a map
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
