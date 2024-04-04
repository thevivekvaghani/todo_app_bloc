import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/profile/edit_profile_cubit.dart';
import 'package:todo_app/bloc/profile/edit_profile_state.dart';
import 'package:todo_app/core/models/user_profile_model.dart';
import 'package:todo_app/core/services/toast_service.dart';
import 'package:todo_app/core/utils/extensions.dart';
import 'package:todo_app/core/widgets/app_elevated_button.dart';
import 'package:todo_app/core/widgets/app_text_form_field.dart';
import 'package:todo_app/data/enums/api_state_status.dart';
import 'package:todo_app/presentation/home/home_layout.dart';

class EditProfile extends StatefulWidget {
  final UserProfileModel userProfile;
  const EditProfile({Key? key, required this.userProfile}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  DateTime dob = DateTime.now();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController = TextEditingController(text: widget.userProfile.name);
    addressController = TextEditingController(text: widget.userProfile.address);
    cityController = TextEditingController(text: widget.userProfile.city);
    pinCodeController = TextEditingController(text: widget.userProfile.pinCode);
    dobController = TextEditingController(
      text: widget.userProfile.dateOfBirth.toStandardDate(),
    );
    dob = widget.userProfile.dateOfBirth;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SafeArea(
        child:  Form(
          key: formKey,
          child: BlocConsumer<EditProfileCubit, EditProfileState>(
            listener: (context, state) {
              if (state.status == ApiStateStatus.success) {
                formKey.currentState!.reset();
                Navigator.pushReplacement(
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
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
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
                        height: 20,
                      ),
                      AppTextFormField(
                        hintText: "Date Of Birth",
                        controller: dobController,
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            helpText: "Select Date",
                            initialDate: dob,
                            firstDate: DateTime(1500),
                            lastDate: DateTime.now().add(Duration(days: 7000)),
                          );
                          if (picked != null) {
                            setState(() {
                              dob = picked;
                              dobController.text = picked.toStandardDate();
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
                      const SizedBox(
                        height: 20,
                      ),
                      AppTextFormField(
                        controller: addressController,
                        hintText: "Address",
                        validator: (val) {
                          if (val?.isEmpty ?? true) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppTextFormField(
                        controller: cityController,
                        hintText: "City",
                        validator: (val) {
                          if (val?.isEmpty ?? true) {
                            return 'Please enter city';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppTextFormField(
                        controller: pinCodeController,
                        hintText: "Pin Code",
                        validator: (val) {
                          if (val?.isEmpty ?? true) {
                            return 'Please enter pin code';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: AppElevatedButton(
                    text: "Submit".toUpperCase(),
                    loading: state.status == ApiStateStatus.loading,
                    onPressed: () {
                      if ((formKey.currentState?.validate() ?? false)) {
                        context.read<EditProfileCubit>().updateUserProfile(
                          name: nameController.text.trim(),
                          address: addressController.text.trim(),
                          city: cityController.text.trim(),
                          pinCode: pinCodeController.text.trim(),
                          dateOfBirth: dob,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),


        ),
      ),
    );
  }
}
