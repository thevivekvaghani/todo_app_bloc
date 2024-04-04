import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/auth/auth_cubit.dart';
import 'package:todo_app/bloc/profile/edit_profile_cubit.dart';
import 'package:todo_app/bloc/profile/profile_cubit.dart';
import 'package:todo_app/bloc/task/add_task_cubit.dart';
import 'package:todo_app/bloc/task/edit_task_cubit.dart';
import 'package:todo_app/bloc/task/task_cubit.dart';
import 'package:todo_app/core/theme/app_theme.dart';
import 'package:todo_app/core/utils/shared_preferences.dart';
import 'package:todo_app/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initSharedPref();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (value) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (BuildContext context) => AuthCubit(),
          lazy: true,
        ),
        BlocProvider<ProfileCubit>(
          create: (BuildContext context) => ProfileCubit(),
          lazy: true,
        ),
        BlocProvider<EditProfileCubit>(
          create: (BuildContext context) => EditProfileCubit(),
          lazy: true,
        ),
        BlocProvider<TaskCubit>(
          create: (BuildContext context) => TaskCubit(),
          lazy: true,
        ),
        BlocProvider<AddTaskCubit>(
          create: (BuildContext context) => AddTaskCubit(),
          lazy: true,
        ),
        BlocProvider<EditTaskCubit>(
          create: (BuildContext context) => EditTaskCubit(),
          lazy: true,
        ),
      ],
      child: MaterialApp(
        title: 'Todo App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.defaultTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
