import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fsp_starter/core/constants/app_routes.dart';
import 'package:fsp_starter/core/widgets/app_widgets.dart';
import 'package:fsp_starter/features/auth/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(loginViewModelProvider);
    ref.listen(loginViewModelProvider, (previous, next) {
      if (next.status == .success) {
        context.go(AppRoutes.home);
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
                          'Log in',
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
                            hintText: 'Your email',
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
                          const Text('Password'),
                          AppTextField(
                            hintText: 'Password', 
                            controller: _passwordController,
                            obscureText: !state.showPassword,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            isPassword: true,
                            onPasswordToggle: ref.read(loginViewModelProvider.notifier).togglePassword,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: .centerRight,
                        child: GestureDetector(
                          onTap: () {
                            print('forgot password');
                          },
                          child: const Text('Forgot password?')
                        ),
                      ),
                      const SizedBox(height: 30),
                      AppButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ref.read(loginViewModelProvider.notifier).login(_emailController.text.trim(), _passwordController.text.trim());
                          }
                        },
                        isLoading: state.status == .loading,
                        text: 'Log in',
                      ),
                      const SizedBox(height: 18),
                      Text.rich(
                        TextSpan(
                          text: 'Don\'t have an account? ',
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(fontWeight: .bold),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                context.go(AppRoutes.signup);
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
