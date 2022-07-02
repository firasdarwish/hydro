/*
 * Copyright 2022 Firas M. Darwish <firas@dev.sy>
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

/// Contains package's main functionality
library hydro;

export 'package:hydro/hydro.dart';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

abstract class Hydro {
  static final Map<Type, _Quark> _quarks = {};

  /// Adds a service (class object) to the container.
  /// In case the service already exists in the container, this will have no effects.
  /// to force replace the existing service (if any), set `forceReplace: true`.
  static void set(Object o, {forceReplace = false}) {
    Type rType = o.runtimeType;
    _Quark? q = _quarks[rType];

    if (q == null) {
      if (o is! Hydro) {
        debugPrint("[HYDRO]: `${o.runtimeType}` is not a subclass of Hydro.");
      }
      _quarks[rType] = _Quark(impl: o, states: []);
      return;
    }

    if (forceReplace) {
      _quarks[rType]!.impl = o;
      if (_quarks[rType]!.autoCleanUnmountedStates) {
        _quarks[rType]!.cleanUnmountedStates();
      }
      _quarks[rType]!.update();
    }
  }

  /// Retrieves a service from the services container, if any.
  /// If service of type `T`, does not already exist, this will return `null`.
  ///
  /// If used inside a class which inherits from the abstract, generic class `State`,
  /// then, set argument `state` to `this`.
  ///
  /// if `state` is null, the UI will NOT re-render when changes occur.
  static T? get<T>([State? state]) {
    if (T == dynamic) {
      debugPrint(
          "[HYDRO]: method `get/mustGet` was called without type parameter or it's type parameter is `dynamic`.");
    }

    var q = _quarks[T];
    if (q == null) return null;

    if (state != null) q.addStateIfNotExists(state);

    if (q.autoCleanUnmountedStates) q.cleanUnmountedStates();

    return q.impl;
  }

  /// Same as `get` method, but without the nullability.
  ///
  /// NOTE: this will throw an exception if service of type `T` does not exist
  /// in the service container.
  static T mustGet<T>([State? state]) {
    return get<T>(state)!;
  }

  /// Updates the UI
  ///
  /// calls `setState` on each `State` base class of a `StatefulWidget` class
  /// that has been associated with the service. (check `get`'s method argument & SomeClass extends Hydro),
  /// EXCEPT for `State` classes which has been unmounted/disposed.
  void update() {
    _quarks[runtimeType]?.update();
  }

  /// Removes `State` from UI update list.
  /// Usually called at the end of the widget's lifecycle,
  /// when a StatefulWidget's State is no longer
  /// used/shown and is removed from the widget tree (unmounted).
  ///
  /// Although not necessary because Hydro will auto-clean the update list
  /// at each call of `get` or `mustGet` methods, this might be helpful in preventing
  /// any unaccounted-for memory leaks.
  static void dispose<T>(State state) {
    if (T == dynamic) {
      debugPrint(
          "[HYDRO]: method `dispose` was called without type parameter or it's type parameter is `dynamic`.");
    }
    _quarks[T]?.removeState(state);
  }
}

class _Quark<T> extends State {
  List<State> states = [];
  late T impl;

  bool autoCleanUnmountedStates = true;

  void cleanUnmountedStates() {
    states = states.where((element) => element.mounted).toList();
  }

  void clearAllStates() {
    states = [];
  }

  void removeState(State state) {
    states.removeWhere((element) => element == state);
  }

  void update() {
    for (int i = 0; i < states.length; i++) {
      if (states[i].mounted) states[i].setState(() {});
    }
  }

  void addStateIfNotExists(State state) {
    var st = states.firstWhereOrNull((element) => element == state);
    if (st == null) {
      states.add(state);
    }
  }

  _Quark({required this.impl, required this.states});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
