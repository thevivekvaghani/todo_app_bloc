import 'package:flutter/material.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/presentation/home/home.dart';
import 'package:todo_app/presentation/profile/user_profile.dart';
import 'package:todo_app/presentation/task/add_task.dart';
import 'package:todo_app/presentation/task/tasks.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTask(),
            ),
          );
        },
      ),
      body: currentIndex == 0
          ? const Home()
          : currentIndex == 1
              ? const Tasks()
              : currentIndex == 2
                  ? const UserProfile()
                  : const SizedBox(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 4,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 36,
              color: AppColors.inActiveIconColor,
            ),
            activeIcon: Icon(
              Icons.home_outlined,
              color: AppColors.iconColor,
              size: 36,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.task_outlined,
              size: 36,
              color: AppColors.inActiveIconColor,
            ),
            activeIcon: Icon(
              Icons.task_outlined,
              size: 36,
              color: AppColors.iconColor,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 36,
              color: AppColors.inActiveIconColor,
            ),
            activeIcon: Icon(
              Icons.person,
              size: 36,
              color: AppColors.iconColor,
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
