import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/auth/auth_cubit.dart';
import 'package:todo_app/bloc/auth/auth_state.dart';
import 'package:todo_app/core/services/toast_service.dart';
import 'package:todo_app/core/theme/app_colors.dart';
import 'package:todo_app/core/theme/app_text_style.dart';
import 'package:todo_app/core/widgets/app_elevated_button.dart';
import 'package:todo_app/core/widgets/app_text_form_field.dart';
import 'package:todo_app/data/enums/api_state_status.dart';
import 'package:todo_app/presentation/home/home_layout.dart';
import 'package:todo_app/presentation/register/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              builder: (context, state) =>  Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      text: "Login",
                      loading: state.status == ApiStateStatus.loading,
                      onPressed: (){
                        if ((formKey.currentState?.validate() ?? false)){
                          context.read<AuthCubit>().login(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20,),
                    Text.rich(
                      TextSpan(
                        text: "Don’t have an account? ",
                        style: AppTextStyle.boldText16,
                        children: [
                          TextSpan(
                            text: "Register",
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Register(),
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
    );
  }
}
