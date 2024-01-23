import 'package:bloc/bloc.dart';
import 'package:employee_assignment/models/employee.dart'; // Replace with your actual project structure
import 'package:employee_assignment/data/database_helper.dart';

import 'employee_state.dart'; // Replace with your actual project structure


class EmployeeCubit extends Cubit<EmployeeState> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  EmployeeCubit() : super(EmployeeState(employees: []));

  Future<void> loadData() async {
    print('Loading data...');
    emit(EmployeeState.loading());
    try {
      final employees = await dbHelper.getEmployees();
      print('Loaded data: $employees');
      emit(EmployeeState.loaded(employees));
    } catch (e) {
      print('Error loading employees: $e');
      emit(EmployeeState.error('Error loading employees: $e'));
    }
  }

  Future<void> deleteEmployee(Employee employee) async {
    try {
      // Delete the employee from the local database
      await dbHelper.deleteEmployee(employee);
      // Load updated data after deletion
      loadData();
    } catch (e) {
      emit(EmployeeState.error('Error deleting employee: $e'));
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    await dbHelper.updateEmployee(employee);
    loadData(); // Reload data after updating
  }

  // Add a new employee to the database
  Future<void> addEmployee(Employee employee) async {
    await dbHelper.insertEmployee(employee);
    loadData(); // Reload data after adding
  }

// ... other CRUD methods
}