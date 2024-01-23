import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../cubits/employee_cubit.dart';
import '../custom_date_picker.dart';
import '../models/employee.dart';

class EditEmployeePage extends StatefulWidget {
  final Employee employee;

  const EditEmployeePage({Key? key, required this.employee}) : super(key: key);

  @override
  _EditEmployeePageState createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  late TextEditingController nameController;
  late TextEditingController jobRoleController;
  late TextEditingController fromDateController;
  late TextEditingController toDateController;

  DateTime? selectedFromDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.employee.name);
    jobRoleController = TextEditingController(text: widget.employee.jobRole);
    fromDateController = TextEditingController(text: widget.employee.startDate);
    toDateController =
        TextEditingController(text: widget.employee.endDate ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Edit Employee'),
        actions: [
          IconButton(
            iconSize: 24.w,
            icon: const Icon(Icons.delete),
            color: Theme.of(context).canvasColor,
            onPressed: () {
              _deleteEmployee(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: 'Employee Name',
                prefixIcon: SizedBox(
                    width: ScreenUtil().setWidth(15),
                    height: ScreenUtil().setHeight(14.62),
                    child: Icon(Icons.person_2_outlined,
                        color: Theme.of(context).primaryColor)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the name';
                }
                return null;
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(24),
            ),
            TextFormField(
              onTap: () {
                _showRolePicker(context);
              },
              readOnly: true,
              controller: jobRoleController,
              style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: 'Select role',
                prefixIcon: SizedBox(
                    width: ScreenUtil().setWidth(15),
                    height: ScreenUtil().setHeight(14.62),
                    child: Icon(Icons.work_outline,
                        color: Theme.of(context).primaryColor)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select the role';
                }
                return null;
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(24),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: TextFormField(
                      onTap: () async {
                        final pickedDate = (await showDialog<DateTime?>(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDatePicker(isFromDate: true,
                                fromDate: selectedFromDate);
                          },
                        ));

                        if (pickedDate != null) {
                          setState(() {
                            selectedFromDate = pickedDate;
                            fromDateController.text =
                                DateFormat('dd MMM yyyy').format(pickedDate);
                          });
                        }
                      },
                      readOnly: true,
                      controller: fromDateController,
                      style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        hintText: 'Today',
                        hintStyle: const TextStyle(color: Colors.black),
                        prefixIcon: SizedBox(
                            width: ScreenUtil().setWidth(15),
                            height: ScreenUtil().setHeight(14.62),
                            child: Icon(Icons.date_range_rounded,
                                color: Theme.of(context).primaryColor)),
                      ),
                    ),
                  ),
                  SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: Icon(Icons.arrow_right_alt_rounded,
                            color: Theme.of(context).primaryColor),
                      )),
                  Flexible(
                    child: TextFormField(
                      onTap: () async {
                        final pickedDate = (await showDialog<DateTime?>(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDatePicker(isFromDate: false,
                              fromDate: selectedFromDate,);
                          },
                        ));
                        if (pickedDate != null) {
                          print(pickedDate);
                          setState(() {
                            toDateController.text =
                                DateFormat('dd MMM yyyy').format(pickedDate);
                          });
                        }
                        else{
                          setState(() {
                            toDateController.text='No Date';
                            toDateController.clear();
                          });
                        }
                      },
                      readOnly: true,
                      controller: toDateController,
                      style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        hintText: 'No date',
                        prefixIcon: SizedBox(
                            width: ScreenUtil().setWidth(15),
                            height: ScreenUtil().setHeight(14.62),
                            child: Icon(Icons.date_range_rounded,
                                color: Theme.of(context).primaryColor)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Divider(color: Theme.of(context).dividerColor,),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(color: Theme.of(context).primaryColor), backgroundColor: const Color(0xFFEDF8FF),
                      foregroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text('Cancel',style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500),),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        final name = nameController.text;
                        final jobRole = jobRoleController.text;
                        final fromDate = fromDateController.text;
                        final toDate = toDateController.text;

                        // Check if fromDate is less than toDate
                        if (toDate.isNotEmpty &&
                            DateFormat('dd MMM yyyy').parse(fromDate).isAfter(
                              DateFormat('dd MMM yyyy').parse(toDate),
                            )) {
                          // Show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('From date should be before To date'),
                            ),
                          );
                        } else {
                          // Proceed with updating the employee
                          final updatedEmployee = Employee(
                            id: widget.employee.id,
                            name: name,
                            jobRole: jobRole,
                            startDate: fromDate,
                            endDate: toDate.isNotEmpty ? toDate : null,
                          );
                          context.read<EmployeeCubit>().updateEmployee(updatedEmployee);

                          Navigator.of(context).pop(); // Navigate back after updating
                        }
                      },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(), backgroundColor: const Color(0xFF1DA1F2),
                      foregroundColor: Theme.of(context).canvasColor,
                      // Background color for save button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text('Save',style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500),),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _deleteEmployee(BuildContext context) {
    final employeeCubit = context.read<EmployeeCubit>();
    employeeCubit.deleteEmployee(widget.employee);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Employee deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            employeeCubit.addEmployee(widget.employee);
            Navigator.of(context).pop();
          },
        ),
      ),
    ); // Refresh the data after deletion
    Navigator.of(context).pop();
  }

  void _showRolePicker(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).canvasColor,
      context: context,
      builder: (BuildContext builder) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title:  Center(child: Text('Product Designer',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp,))),
              onTap: () {
                setState(() {
                  jobRoleController.text = 'Product Designer';
                });
                Navigator.pop(context);
              },
            ),
            Divider(
              height: 1.w,
              color: Theme.of(context).hintColor,
            ),
            ListTile(
              title:  Center(child: Text('Flutter Developer',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp,))),
              onTap: () {
                setState(() {
                  jobRoleController.text = 'Flutter Developer';
                });
                Navigator.pop(context);
              },
            ),
            Divider(
              height: 1.w,
              color: Theme.of(context).hintColor,
            ),
            ListTile(
              title:  Center(child: Text('QA Tester',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp,))),
              onTap: () {
                setState(() {
                  jobRoleController.text = 'QA Tester';
                });
                Navigator.pop(context);
              },
            ),
            Divider(
              height: 1.w,
              color: Theme.of(context).hintColor,
            ),
            ListTile(
              title:  Center(child: Text('Product Owner',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp,))),
              onTap: () {
                setState(() {
                  jobRoleController.text = 'Product Owner';
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

