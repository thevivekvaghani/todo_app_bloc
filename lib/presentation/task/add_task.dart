import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/task/add_task_cubit.dart';
import 'package:todo_app/bloc/task/task_cubit.dart';
import 'package:todo_app/bloc/task/task_state.dart';
import 'package:todo_app/core/services/toast_service.dart';
import 'package:todo_app/core/theme/app_text_style.dart';
import 'package:todo_app/core/utils/extensions.dart';
import 'package:todo_app/core/widgets/app_elevated_button.dart';
import 'package:todo_app/core/widgets/app_text_form_field.dart';
import 'package:todo_app/data/enums/api_state_status.dart';
import 'package:todo_app/presentation/home/home_layout.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  DateTime dueDate = DateTime.now();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      body: Form(
        key: formKey,
        child: BlocConsumer<AddTaskCubit, TaskState>(
          listener: (context, state) {
            if (state.status == ApiStateStatus.success) {
              formKey.currentState!.reset();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeLayout(),
                ),
              );
            }
            if (state.status == ApiStateStatus.error) {
              showErrorToast(context, text: state.error ?? '');
            }
          },
          builder: (context, state) => Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("What is to be Done?",style: AppTextStyle.bodyText14,),
                      const SizedBox(height: 8,),
                      AppTextFormField(
                        controller: nameController,
                        hintText: "Name",
                        validator: (val) {
                          if (val?.isEmpty ?? true) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text("Due Date",style: AppTextStyle.bodyText14,),
                      const SizedBox(height: 8,),
                      AppTextFormField(
                        hintText: "Due Date",
                        controller: dueDateController,
                        readOnly: true,
                        suffixIcon: const Icon(
                          Icons.date_range_rounded,
                          size: 26,
                        ),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            helpText: "Select Date",
                            initialDate: dueDate,
                            firstDate: DateTime(1500),
                            lastDate: DateTime.now().add(Duration(days: 7000)),
                          );
                          if (picked != null) {
                            setState(() {
                              dueDate = picked;
                              dueDateController.text = picked.toStandardDate();
                            });
                          }
                        },
                        validator: (val) {
                          if (val?.isEmpty ?? true) {
                            return 'Please select date';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: AppElevatedButton(
                  text: "Submit".toUpperCase(),
                  loading: state.status == ApiStateStatus.loading,
                  onPressed: () {
                    if ((formKey.currentState?.validate() ?? false)) {
                      context.read<AddTaskCubit>().addTask(
                        name: nameController.text.trim(),
                        dueDate: dueDate,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),


      ),
    );
  }
}
