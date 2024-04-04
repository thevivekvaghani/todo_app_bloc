import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/task/add_task_cubit.dart';
import 'package:todo_app/bloc/task/task_cubit.dart';
import 'package:todo_app/bloc/task/task_state.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_constants.dart';
import 'package:todo_app/core/theme/app_text_style.dart';
import 'package:todo_app/core/utils/extensions.dart';
import 'package:todo_app/data/enums/api_state_status.dart';
import 'package:todo_app/data/enums/task_status.dart';
import 'package:todo_app/presentation/task/edit_task.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    context.read<TaskCubit>().get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
        leading: SizedBox(),
        leadingWidth: 0,
      ),
      body: SafeArea(
        child: BlocConsumer<TaskCubit, TaskState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.status == ApiStateStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status == ApiStateStatus.error) {
              return Center(child: Text(state.error ?? "Something Went Wrong"));
            } else if (state.status == ApiStateStatus.success) {
              final response = state.response!;
              final groupByDate = response
                  .groupBy((item) => item.dueDate.toLocal());
              if (groupByDate.isEmpty) {
                return const Center(
                  child: Text(
                    "Task list not found.",
                  ),
                );
              } else {
                return ListView(
                  children: [
                    ...groupByDate.keys.map(
                      (key) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            if (groupByDate[key]!.isNotEmpty &&
                                groupByDate[key]!.any((element) =>
                                    element.status == TaskStatus.pending))
                              Text(
                                key.getCurrentStatus().toUpperCase(),
                                style: AppTextStyle.boldText16,
                              ),
                            if (groupByDate[key]!.isNotEmpty)
                              ...groupByDate[key]!.map(
                                (e) {
                                  if (e.status == TaskStatus.pending) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular( 
                                          AppConstants.cardMediumRadius,
                                        ),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditTask(model: e),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value: e.status ==
                                                    TaskStatus.completed,
                                                onChanged: (val) {
                                                  context
                                                      .read<AddTaskCubit>()
                                                      .updateStatus(
                                                        id: e.id,
                                                        status:
                                                            TaskStatus.completed,
                                                      );
                                                  context.read<TaskCubit>().get();
                                                },
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      e.name,
                                                      style:
                                                          AppTextStyle.boldText18,
                                                    ),
                                                    Text(
                                                      e.dueDate.toStandardDate(),
                                                      style: AppTextStyle
                                                          .bodyText14
                                                          .copyWith(
                                                        color: AppColors
                                                            .darkTextColor,
                                                        height: 1.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  await context
                                                      .read<AddTaskCubit>()
                                                      .deleteTask(id: e.id);
                                                  context.read<TaskCubit>().get();
                                                },
                                                icon: const Icon(
                                                  Icons.delete_forever,
                                                  color: AppColors.redColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
