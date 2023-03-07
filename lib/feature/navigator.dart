import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ufcat_ru_check/ui/transitions.dart';

class RUCheckNavigator {
  static Route<T> getRouteSlide<T>({
    required Widget to,
    Object? arguments,
    String? name,
  }) {
    return PageRouteBuilder(
      settings: RouteSettings(arguments: arguments, name: name),
      pageBuilder: (context, animation, secondaryAnimation) => to,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          RUCheckTransitions.rightToLeftSlide(child, animation),
    );
  }

  static Route<T> getRouteFade<T>({
    required Widget to,
    String? name,
  }) {
    return PageRouteBuilder(
      settings: RouteSettings(name: name),
      pageBuilder: (_, __, ___) => to,
      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
    );
  }
}

extension ContextExtensions on BuildContext {
  String restorableNavigateNamed<T, TO>({
    required String name,
    bool replace = false,
    bool root = false,
    RoutePredicate? replacePredicate,
    Object? arguments,
  }) {
    if (replace) {
      return Navigator.restorablePushReplacementNamed(
        this,
        name,
        arguments: arguments,
      );
    } else if (root) {
      return Navigator.restorablePushNamedAndRemoveUntil(
        this,
        name,
        (_) => false,
        arguments: arguments,
      );
    } else if (replacePredicate != null) {
      return Navigator.restorablePushNamedAndRemoveUntil(
        this,
        name,
        replacePredicate,
        arguments: arguments,
      );
    }
    return Navigator.restorablePushNamed(this, name, arguments: arguments);
  }

  Future<T?> navigateSlide<T, TO>({
    required Widget to,
    bool replace = false,
    bool root = false,
    RoutePredicate? replacePredicate,
    Object? arguments,
    String? name,
  }) {
    if (replace) {
      return Navigator.of(this).pushReplacement<T, dynamic>(
        RUCheckNavigator.getRouteSlide(
          to: to,
          arguments: arguments,
          name: name,
        ),
      );
    } else if (root) {
      return Navigator.of(this).pushAndRemoveUntil(
        RUCheckNavigator.getRouteSlide(
          to: to,
          arguments: arguments,
          name: name,
        ),
        (_) => false,
      );
    } else if (replacePredicate != null) {
      return Navigator.of(this).pushAndRemoveUntil(
        RUCheckNavigator.getRouteSlide(
          to: to,
          arguments: arguments,
          name: name,
        ),
        replacePredicate,
      );
    }
    return Navigator.of(this).push<T>(
      RUCheckNavigator.getRouteSlide(to: to, arguments: arguments, name: name),
    );
  }

  Future<T?> navigateFade<T, TO>({
    required Widget to,
    bool replace = false,
    bool root = false,
    RoutePredicate? replacePredicate,
    Object? arguments,
    String? name,
  }) {
    return Navigator.of(this).navigateFade(
      to: to,
      replace: replace,
      root: root,
      replacePredicate: replacePredicate,
      arguments: arguments,
      name: name,
    );
  }
}

extension NavigatorHelper on NavigatorState {
  Future<T?> navigateFade<T, TO>({
    required Widget to,
    bool replace = false,
    bool root = false,
    RoutePredicate? replacePredicate,
    Object? arguments,
    String? name,
  }) {
    if (replace) {
      return pushReplacement<T, dynamic>(
        RUCheckNavigator.getRouteFade(to: to, name: name),
      );
    } else if (root) {
      return pushAndRemoveUntil(
        RUCheckNavigator.getRouteFade(to: to, name: name),
        (_) => false,
      );
    } else if (replacePredicate != null) {
      return pushAndRemoveUntil(
        RUCheckNavigator.getRouteSlide(
          to: to,
          arguments: arguments,
          name: name,
        ),
        replacePredicate,
      );
    }
    return push<T>(RUCheckNavigator.getRouteFade(to: to, name: name));
  }
}

RestorableRouteFuture<T> getRestorableRoute<T>({
  required RestorableRouteBuilder<T> route,
  bool replace = false,
  bool root = false,
  RoutePredicate? replacePredicate,
  RouteCompletionCallback<T>? onComplete,
  NavigatorFinderCallback? navigatorFinder,
}) {
  return RestorableRouteFuture<T>(
    navigatorFinder: navigatorFinder ?? (context) => Navigator.of(context),
    onPresent: (navigator, args) {
      if (replace) {
        return navigator.restorablePushReplacement<T, dynamic>(
          route,
          arguments: args,
        );
      } else if (root) {
        return navigator.restorablePushAndRemoveUntil(
          route,
          (_) => false,
          arguments: args,
        );
      } else if (replacePredicate != null) {
        return navigator.restorablePushAndRemoveUntil(
          route,
          replacePredicate,
          arguments: args,
        );
      }
      return navigator.restorablePush<T>(route, arguments: args);
    },
    onComplete: onComplete,
  );
}
