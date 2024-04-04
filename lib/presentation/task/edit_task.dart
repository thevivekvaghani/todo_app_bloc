import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/task/add_task_cubit.dart';
import 'package:todo_app/bloc/task/edit_task_cubit.dart';
import 'package:todo_app/bloc/task/task_cubit.dart';
import 'package:todo_app/bloc/task/task_state.dart';
import 'package:todo_app/core/models/task_model.dart';
import 'package:todo_app/core/services/toast_service.dart';
import 'package:todo_app/core/theme/app_text_style.dart';
import 'package:todo_app/core/utils/extensions.dart';
import 'package:todo_app/core/widgets/app_elevated_button.dart';
import 'package:todo_app/core/widgets/app_text_form_field.dart';
import 'package:todo_app/data/enums/api_state_status.dart';
import 'package:todo_app/presentation/home/home_layout.dart';

class EditTask extends StatefulWidget {
  final TaskModel model;
  const EditTask({Key? key, required this.model}) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  DateTime dueDate = DateTime.now();
  final formKey = GlobalKey<FormState>();


  @override
  void initState() {
    dueDate = widget.model.dueDate;
    dueDateController = TextEditingController(text: widget.model.dueDate.toStandardDate());
    nameController = TextEditingController(text: widget.model.name,);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      body: Form(
        key: formKey,
        child: BlocConsumer<EditTaskCubit, TaskState>(
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
                      context.read<EditTaskCubit>().editTask(
                        id: widget.model.id,
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
