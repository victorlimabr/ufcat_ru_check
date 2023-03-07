import 'package:flutter/material.dart';
import 'package:ufcat_ru_check/data/result.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';
import 'package:ufcat_ru_check/domain/auth/sign_up_use_case.dart';
import 'package:ufcat_ru_check/feature/dashboard/dashboard_page.dart';
import 'package:ufcat_ru_check/feature/navigator.dart';
import 'package:ufcat_ru_check/feature/sign_up/sign_up_bloc.dart';
import 'package:ufcat_ru_check/ui/components/error_snackbar.dart';
import 'package:ufcat_ru_check/utils/context_extensions.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formkey = GlobalKey<FormState>();
  final _signUpBloc = ServiceLocator.get<SignUpBLoC>();
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _documentController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    _signUpBloc.stream.listen((result) {
      if (result is SignUpSuccessState) {
        context.navigateFade(to: const DashboardPage());
      } else if (result is ResultError<SignUpUseCaseOutput>) {
        context.showErrorSnackBar(result.exception.toString());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _documentController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          'Primeiro Acesso',
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
                              child: _formFields(context),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 32,
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  Expanded(child: _backButton(context)),
                                  Expanded(child: _signUpButton(context)),
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
    );
  }

  Column _formFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _textField(context, _nameController, 'Nome Completo'),
        _textField(context, _identifierController, 'Usuário Sigaa'),
        _textField(context, _documentController, 'CPF'),
        _textField(context, _emailController, 'Email'),
        _textField(context, _passwordController, 'Senha', obscure: true),
      ],
    );
  }

  Widget _backButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Voltar'),
      ),
    );
  }

  Widget _signUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FilledButton(
        onPressed: () => _signUp(context),
        child: const Text('Cadastrar'),
      ),
    );
  }

  void _signUp(BuildContext context) {
    if (_formkey.currentState!.validate()) {
      _signUpBloc.add(
        SignUpSignEvent(
          _nameController.text,
          _identifierController.text,
          _documentController.text,
          _emailController.text,
          _passwordController.text,
        ),
      );
    }
  }

  Widget _textField(
    BuildContext context,
    TextEditingController controller,
    String label, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        obscureText: obscure,
        validator: (email) {
          if (email?.isEmpty ?? true) {
            return 'Obrigatório';
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(label),
        ),
      ),
    );
  }
}
