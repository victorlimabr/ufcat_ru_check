import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';
import 'package:ufcat_ru_check/feature/navigator.dart';
import 'package:ufcat_ru_check/feature/sign_in/bloc/sign_in_event.dart';
import 'package:ufcat_ru_check/feature/sign_in/bloc/sign_in_state.dart';
import 'package:ufcat_ru_check/feature/sign_in/sign_in_bloc.dart';
import 'package:ufcat_ru_check/feature/sign_up/sign_up_page.dart';
import 'package:ufcat_ru_check/ui/components/error_snackbar.dart';
import 'package:ufcat_ru_check/utils/context_extensions.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceLocator.get<SignInBLoC>(),
      child: BlocListener<SignInBLoC, SignInState>(
        listener: (context, state) {
          if (state.status == FormzStatus.submissionFailure) {
            context.showErrorSnackBar('FAIL');
          }
        },
        child: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FractionallySizedBox(
                widthFactor: 1 / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                        color: context.cardColor,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: SizedBox(
                        width: 464,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 48),
                              child: Text(
                                'UFCat - RU Check',
                                style: context.displayLarge,
                              ),
                            ),
                            Form(
                              key: _formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: _formFields(context, context.read()),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 32,
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(child: _signUpButton(context)),
                                        Expanded(child: _enterButton(context)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

  Column _formFields(BuildContext context, SignInBLoC bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _textField(context, (email) => bloc.add(SignInEmailChanged(email ?? '')), 'E-mail'),
        _textField(context, (password) => bloc.add(SignInPasswordChanged(password ?? '')), 'Senha', obscure: true),
      ],
    );
  }

  Widget _signUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton(
        onPressed: () => _navigateToSignUp(context),
        child: const Text('Primeiro acesso'),
      ),
    );
  }

  Widget _enterButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FilledButton(
        onPressed: () => _signIn(context),
        child: const Text('Entrar'),
      ),
    );
  }

  void _navigateToSignUp(BuildContext context) {
    context.navigateFade(to: const SignUpPage());
  }

  void _signIn(BuildContext context) {
    if (_formkey.currentState!.validate()) {
      context.read<SignInBLoC>().add(const SignInSubmitted());
    }
  }

  Widget _textField(
    BuildContext context,
    ValueChanged<String?> onChanged,
    String label, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        obscureText: obscure,
        validator: (email) {
          if (email?.isEmpty ?? true) {
            return 'Obrigatório';
          }
          return null;
        },
        decoration: InputDecoration(
            border: const OutlineInputBorder(), label: Text(label)),
      ),
    );
  }
}
