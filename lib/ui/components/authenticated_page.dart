import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ufcat_ru_check/data/employee/employee.dart';
import 'package:ufcat_ru_check/data/employee/employee_dao.dart';
import 'package:ufcat_ru_check/di/service_locator.dart';

abstract class AuthenticatedPage extends StatelessWidget {
  const AuthenticatedPage({super.key});

  FirebaseAuth get _auth => ServiceLocator.get<FirebaseAuth>();

  Future<Employee?> get currentEmployee async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return EmployeeEntity.find(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (context, snap) {
        switch (snap.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.active:
            return _activeWidget(context, snap);
          case ConnectionState.none:
          case ConnectionState.done:
            return Container();
        }
      },
    );
  }

  Widget _activeWidget(BuildContext context, AsyncSnapshot<User?> snapshot) {
    if (snapshot.hasData) {
      return FutureBuilder<Employee?>(
        future: currentEmployee,
        builder: (context, snapshot) {
          if (snapshot.data != null) return authBuild(context, snapshot.data!);
          return Container();
        },
      );
    } else if (snapshot.hasError) {}
    return Container();
  }

  Widget authBuild(BuildContext context, Employee employee);
}
