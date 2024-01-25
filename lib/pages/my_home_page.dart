import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_assignment/cubits/employee_cubit.dart';
import 'package:employee_assignment/models/employee.dart';
import 'package:employee_assignment/pages/add_employee.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubits/employee_state.dart';
import 'edit_employee_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late EmployeeCubit _employeeCubit;
  List<Employee> employees = [];

  @override
  void initState() {
    super.initState();
    _employeeCubit = context.read<EmployeeCubit>();
    _employeeCubit.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, EmployeeState>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: _buildBody(context, state),
          floatingActionButton: SizedBox(
            width: 50.w,
            height: 50.h,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () => _navigateToAddEmployee(context),
                tooltip: 'Add Employee',
                child: const Icon(Icons.add),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, EmployeeState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.error != null) {
      return Center(child: Text('Error: ${state.error}'));
    } else if (state.employees.isEmpty) {
      return Center(
        child: SizedBox(
          width: 261.79.w,
          height: 244.38.h,
          child: Image.asset('assets/images/img.png'),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEmployeeList(
                context, 'Current Employees', _getCurrentEmployees(state)),
            _buildEmployeeList(
                context, 'Previous Employees', _getPreviousEmployees(state)),
          ],
        ),
      );
    }
  }

  Widget _buildEmployeeList(
      BuildContext context, String title, List<Employee> employees) {
    if (employees.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(color: Theme.of(context).dividerColor),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  _deleteEmployee(context, employee);
                },
                background: Container(
                  color: Colors.red,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                child: InkWell(
                  onTap: () => _navigateToEditEmployee(context, employee),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).dividerColor))),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(employee.name ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                              )),
                          Text(employee.jobRole ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              )),
                          Row(
                            children: [
                              if (employee.endDate != null &&
                                  employee.endDate!.isNotEmpty)
                                Text(
                                    '${employee.startDate ?? ''} - ${employee.endDate}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    )),
                              if (employee.endDate == null ||
                                  employee.endDate!.isEmpty)
                                Text('From ${employee.startDate ?? ''}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  void _deleteEmployee(BuildContext context, Employee employee) {
    _employeeCubit.deleteEmployee(employee);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Employee deleted'),
        action: SnackBarAction(
          textColor: Theme.of(context).primaryColor,
          label: 'Undo',
          onPressed: () {
            _employeeCubit.addEmployee(employee);
          },
        ),
      ),
    ); // Refresh the data after deletion
    setState(() {});
  }

  List<Employee> _getCurrentEmployees(EmployeeState state) {
    return state.employees
        .where((employee) => employee.endDate == null)
        .toList();
  }

  List<Employee> _getPreviousEmployees(EmployeeState state) {
    return state.employees
        .where((employee) => employee.endDate != null)
        .toList();
  }

  void _navigateToAddEmployee(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AddEmployeePage()));
  }

  void _navigateToEditEmployee(BuildContext context, Employee employee) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditEmployeePage(employee: employee),
      ),
    );
  }

  @override
  void dispose() {
    _employeeCubit.close();
    super.dispose();
  }
}
