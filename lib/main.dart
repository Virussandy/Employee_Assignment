import 'package:employee_assignment/mytheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employee_assignment/pages/my_home_page.dart'; // Replace with your actual project structure
import 'package:employee_assignment/cubits/employee_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Replace with your actual project structure

void main() {
  runApp( BlocProvider(
    create: (context)=>EmployeeCubit(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (_,child){
        return MaterialApp(
          title: 'Employee App',
          theme: customTheme,
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(title: 'Employee List'),
        );
      },
    );
  }
}