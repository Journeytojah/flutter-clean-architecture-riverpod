// register_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/configs/app_configs.dart';
import 'package:flutter_project/features/authentication/presentation/providers/auth_providers.dart';
import 'package:flutter_project/features/authentication/presentation/providers/state/auth_state.dart';
import 'package:flutter_project/features/authentication/presentation/widgets/auth_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../routes/app_route.dart';

@RoutePage()
class RegisterScreen extends ConsumerWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authStateNotifierProvider);

    ref.listen(
      authStateNotifierProvider.select((value) => value),
      ((previous, next) {
        if (next is Failure) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(next.exception.message.toString())));
        } else if (next is Success) {
          AutoRouter.of(context)
              .pushAndPopUntil(const DashboardRoute(), predicate: (_) => false);
        }
      }),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${AppConfigs.appName} Register'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AuthField(
                hintText: 'Username',
                controller: usernameController,
              ),
              AuthField(
                hintText: 'Email',
                controller: emailController,
              ),
              AuthField(
                hintText: 'Password',
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 20),
              state.maybeMap(
                loading: (_) =>
                    const Center(child: CircularProgressIndicator()),
                orElse: () => Column(
                  children: [
                    registerButton(ref),
                    loginButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget registerButton(WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // Validate inputs, then call registerUser
        ref.read(authStateNotifierProvider.notifier).registerUser(
              emailController.text,
              passwordController.text,
            );
      },
      child: const Text('Register'),
    );
  }

  Widget loginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        AutoRouter.of(context).push(LoginRoute());
      },
      child: const Text('Login'),
    );
  }
}
