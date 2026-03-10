import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fsp_starter/core/constants/app_routes.dart';
import 'package:fsp_starter/core/widgets/app_widgets.dart';
import 'package:fsp_starter/features/auth/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget  {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(registerViewModelProvider);

    ref.listen(registerViewModelProvider, (previous, next) {
      if (next.status == .success) {
        context.go(AppRoutes.login);
      }
    });

    // Get the total screen height
    final double screenHeight = MediaQuery.sizeOf(context).height;
    // Get the keyboard height
    final double keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    // Calculate the available height for your content above the keyboard
    final double availableHeight = screenHeight - keyboardHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: availableHeight),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Spacer(),
                      const Align(
                        alignment: .centerLeft,
                        child: Text(
                          'Sign up',
                          style: TextStyle(fontSize: 30, fontWeight: .bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                  
                      Column(
                        crossAxisAlignment: .start,
                        spacing: 8,
                        children: [
                          const Text('Email address'),
                          AppTextField(
                            hintText: 'you@example.com',
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Column(
                        crossAxisAlignment: .start,
                        spacing: 8,
                        children: [
                          const Text('Create a password'),
                          AppTextField(
                            hintText: 'Password', 
                            obscureText: !state.showPassword,
                            isPassword: true,
                            onPasswordToggle: ref.read(registerViewModelProvider.notifier).togglePassword,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Column(
                        crossAxisAlignment: .start,
                        spacing: 8,
                        children: [
                          const Text('Confirm password'),
                          AppTextField(
                            hintText: 'Repeat password', 
                            obscureText: !state.showConfirmPassword,
                            isPassword: true,
                            onPasswordToggle: ref.read(registerViewModelProvider.notifier).toggleConfirmPassword,
                            controller: _confirmPasswordController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please re-enter your password';
                              }
                              if (value.trim() != _passwordController.text.trim()) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      AppButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ref.read(registerViewModelProvider.notifier).register(_emailController.text.trim(), _passwordController.text.trim());
                          }
                        },
                        text: 'Sign up',
                      ),
                      const SizedBox(height: 18),
                      Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          children: [
                            TextSpan(
                              text: 'Log in',
                              style: TextStyle(fontWeight: .bold),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                context.go(AppRoutes.login);
                              }
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
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