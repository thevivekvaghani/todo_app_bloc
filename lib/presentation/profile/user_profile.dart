import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/profile/edit_profile_cubit.dart';
import 'package:todo_app/bloc/profile/edit_profile_state.dart';
import 'package:todo_app/bloc/profile/profile_cubit.dart';
import 'package:todo_app/bloc/profile/profile_state.dart';
import 'package:todo_app/core/services/toast_service.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_text_style.dart';
import 'package:todo_app/core/utils/app_images.dart';
import 'package:todo_app/core/utils/shared_preferences.dart';
import 'package:todo_app/data/enums/api_state_status.dart';
import 'package:todo_app/presentation/login/login.dart';
import 'package:todo_app/presentation/profile/edit_profile.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    context.read<ProfileCubit>().get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
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
              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.dividerColor,
                    ),
                    height: 76,
                    width: 76,
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        color: AppColors.inActiveIconColor,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: Text(
                      response.name,
                      style: AppTextStyle.boldText24,
                    ),
                  ),
                  Center(
                    child: Text(
                      response.email,
                      style: AppTextStyle.boldText16.copyWith(
                        color: AppColors.darkTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _ItemCard(
                    title: "Edit Profile",
                    imgUrl: AppImages.editProfileIcon,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(
                            userProfile: response,
                          ),
                        ),
                      );
                    },
                  ),
                  BlocConsumer<EditProfileCubit, EditProfileState>(
                    listener: (context, logoutState) {
                      if (logoutState.status == ApiStateStatus.success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Login(),
                          ),
                        );
                      }
                      if (logoutState.status == ApiStateStatus.error) {
                        showErrorToast(context, text: state.error ?? '');
                      }
                    },
                    builder: (context, state) =>_ItemCard(
                      title: "Delete my Account",
                      imgUrl: AppImages.deleteAccountIcon,
                      onTap: () async {
                        context.read<EditProfileCubit>().deleteUserAccount();
                      },
                    ),
                  ),
                  BlocConsumer<EditProfileCubit, EditProfileState>(
                    listener: (context, deleteState) {
                      if (deleteState.status == ApiStateStatus.success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Login(),
                          ),
                        );
                      }
                      if (deleteState.status == ApiStateStatus.error) {
                        showErrorToast(context, text: state.error ?? '');
                      }
                    },
                    builder: (context, state) => _ItemCard(
                      title: "Logout",
                      imgUrl: AppImages.logoutIcon,
                      onTap: () async {
                        context.read<EditProfileCubit>().logoutProfile();
                      },
                    ),
                  ),


                ],
              );
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

class _ItemCard extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final String imgUrl;
  const _ItemCard(
      {Key? key, this.onTap, required this.title, required this.imgUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: AppColors.lightColor),
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  imgUrl,
                  height: 36,
                  width: 36,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: AppTextStyle.boldText16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
