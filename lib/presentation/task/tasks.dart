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

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> with TickerProviderStateMixin{
  late TabController tabController;


  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    context.read<TaskCubit>().get();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        leading: const SizedBox(),
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
                  .groupBy((item) => item.dueDate.toLocal().toStandardDate());
              if (groupByDate.isEmpty) {
                return const Center(
                  child: Text(
                    "Task list not found.",
                  ),
                );
              } else {
                return Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: TabBar(
                        controller: tabController,
                        indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: const [
                          Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.timeline_rounded, size: 20),
                                SizedBox(width: 4),
                                Text("Pending",)
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, size: 20),
                                SizedBox(width: 4),
                                Text("Finished",)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          Column(
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
                                      if(groupByDate[key]!.isNotEmpty && groupByDate[key]!.any((e) => e.status != TaskStatus.completed))
                                        Text(
                                          key.toString().toUpperCase(),
                                          style: AppTextStyle.boldText16,
                                        ),
                                      if(groupByDate[key]!.isNotEmpty)
                                        ...groupByDate[key]!.map(
                                              (e) {
                                                if(e.status != TaskStatus.completed){
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
                                                                  e.status ==
                                                                      TaskStatus.completed ?  TaskStatus.pending :  TaskStatus.completed,
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
                                                                    style: AppTextStyle.bodyText14
                                                                        .copyWith(
                                                                      color:
                                                                      AppColors.darkTextColor,
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
                                                }else {
                                                  return const SizedBox();
                                                }

                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
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
                                      if(groupByDate[key]!.isNotEmpty && groupByDate[key]!.any((e) => e.status == TaskStatus.completed))
                                        Text(
                                          key.toString().toUpperCase(),
                                          style: AppTextStyle.boldText16,
                                        ),
                                      if(groupByDate[key]!.isNotEmpty)
                                        ...groupByDate[key]!.map(
                                              (e) {
                                            if(e.status == TaskStatus.completed){
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
                                                              e.status ==
                                                                  TaskStatus.completed ?  TaskStatus.pending :  TaskStatus.completed,
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
                                                                style: AppTextStyle.bodyText14
                                                                    .copyWith(
                                                                  color:
                                                                  AppColors.darkTextColor,
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
                                            }else {
                                              return const SizedBox();
                                            }

                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
