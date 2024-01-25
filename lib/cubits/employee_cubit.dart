import 'package:bloc/bloc.dart';
import 'package:employee_assignment/models/employee.dart';
import 'package:employee_assignment/data/database_helper.dart';
import 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  EmployeeCubit() : super(EmployeeState(employees: []));

  Future<void> loadData() async {
    emit(EmployeeState.loading());
    try {
      final employees = await dbHelper.getEmployees();
      emit(EmployeeState.loaded(employees));
    } catch (e) {
      emit(EmployeeState.error('Error loading employees: $e'));
    }
  }

  Future<void> deleteEmployee(Employee employee) async {
    try {
      await dbHelper.deleteEmployee(employee);
      loadData();
    } catch (e) {
      emit(EmployeeState.error('Error deleting employee: $e'));
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    await dbHelper.updateEmployee(employee);
    loadData();
  }

  Future<void> addEmployee(Employee employee) async {
    await dbHelper.insertEmployee(employee);
    loadData();
  }
}