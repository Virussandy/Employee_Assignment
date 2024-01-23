import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_assignment/cubits/employee_cubit.dart';
import 'package:employee_assignment/models/employee.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../custom_date_picker.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobRoleController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? selectedFromDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Add Employee Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextFormField(
                controller: nameController,
                style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: 'Employee Name',
                  prefixIcon: SizedBox(
                      width: 15.w,
                      height: 14.62.h,
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
                height: 24.h,
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
                      width: 15.w,
                      height: 14.62.h,
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
                height: 24.h,
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
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          hintText: 'Today',
                          hintStyle: const TextStyle(color: Colors.black),
                          prefixIcon: SizedBox(
                            width: 15.w,
                            height: 14.62.h,
                            child: Icon(Icons.date_range_rounded,
                                color: Theme.of(context).primaryColor),
                          ),
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
                              selectedFromDate = null;
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
                              width: 15.w,
                              height: 14.62.h,
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
                        textStyle: TextStyle(color: Theme.of(context).primaryColor),
                        backgroundColor: Theme.of(context).cardColor,
                        foregroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      child: Text('Cancel', style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500),),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final name = nameController.text;
                          final jobRole = jobRoleController.text;
                          final fromDate = fromDateController.text.isEmpty
                              ? DateFormat('dd MMM yyyy').format(DateTime.now())
                              : fromDateController.text;
                          final toDate = toDateController.text.isEmpty
                              ? null
                              : toDateController.text;

                          // Check if fromDate is less than toDate
                          if (toDate != null &&
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
                            // Proceed with adding the employee
                            final newEmployee = Employee(
                              name: name,
                              jobRole: jobRole,
                              startDate: fromDate,
                              endDate: toDate,
                            );
                            context.read<EmployeeCubit>().addEmployee(newEmployee);

                            Navigator.of(context).pop(); // Navigate back after adding
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(), backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Theme.of(context).canvasColor,
                        // Background color for save button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      child:Text('Save',style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500),),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
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
              title: Center(child: Text('Product Designer',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp,))),
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
