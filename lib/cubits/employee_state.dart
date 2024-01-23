import '../models/employee.dart';

class EmployeeState {
  final List<Employee> employees;
  final bool isLoading;
  final String? error;

  EmployeeState({
    required this.employees,
    this.isLoading = false,
    this.error,
  });

  factory EmployeeState.loading() {
    return EmployeeState(isLoading: true, employees: []);
  }

  factory EmployeeState.loaded(List<Employee> employees) {
    print(employees.length);
    return EmployeeState(isLoading: false, employees: employees);
  }

  factory EmployeeState.error(String error) {
    return EmployeeState(isLoading: false, employees: [], error: error);
  }
}