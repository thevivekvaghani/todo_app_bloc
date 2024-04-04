import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/auth/auth_cubit.dart';
import 'package:todo_app/bloc/auth/auth_state.dart';
import 'package:todo_app/core/services/toast_service.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_text_style.dart';
import 'package:todo_app/core/utils/extensions.dart';
import 'package:todo_app/core/widgets/app_elevated_button.dart';
import 'package:todo_app/core/widgets/app_text_form_field.dart';
import 'package:todo_app/data/enums/api_state_status.dart';
import 'package:todo_app/presentation/home/home_layout.dart';
import 'package:todo_app/presentation/login/login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  DateTime dob = DateTime.now();
  bool obscurePassword = true;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: BlocConsumer<AuthCubit, AuthState>(
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
                builder: (context, state) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      const SizedBox(height: 20,),
                      AppTextFormField(
                        controller: emailController,
                        hintText: "Email",
                        validator: (val) {
                          if (val?.isEmpty ?? true) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20,),
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
                            lastDate:    DateTime.now().add(Duration(days: 7000)),
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
                      const SizedBox(height: 20,),
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
                      const SizedBox(height: 20,),
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
                      const SizedBox(height: 20,),
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
                      const SizedBox(height: 20,),
                      AppTextFormField(
                        controller: passwordController,
                        hintText: "Password",
                        obscureText: obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });

                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 24,
                            color: const Color(0xFF9DA3AA),
                          ),
                        ),
                        validator: (val) {
                          if (val?.isEmpty ?? true) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20,),
                      AppElevatedButton(
                        text: "Register".toUpperCase(),
                        loading: state.status == ApiStateStatus.loading,
                        onPressed: (){
                          if ((formKey.currentState?.validate() ?? false)){
                            context.read<AuthCubit>().signUp(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                address: addressController.text.trim(),
                                city: cityController.text.trim(),
                                pinCode: pinCodeController.text.trim(),
                                password: passwordController.text.trim(),
                                dateOfBirth: dob,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20,),
                      Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: AppTextStyle.boldText16,
                          children: [
                            TextSpan(
                              text: "Login",
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Login(),
                                  ),
                                );
                              },
                              style: AppTextStyle.boldText16.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
