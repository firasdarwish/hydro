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

library hydro;

export 'package:hydro/hydro.dart';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

abstract class Hydro<T> {
  static final Map<Type, _quark> _quarks = {};

  static void set(Object o, {forceReplace = false}) {
    Type rType = o.runtimeType;
    _quark? q = _quarks[rType];

    if (q == null) {
      _quarks[rType] = _quark(impl: o, states: []);
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

  static T? get<T>([State? state]) {
    var q = _quarks[T];
    if (q == null) return null;

    if (state != null) q.addStateIfNotExists(state);

    if (q.autoCleanUnmountedStates) q.cleanUnmountedStates();

    return q.impl;
  }

  static T mustGet<T>([State? state]) {
    return get<T>(state)!;
  }

  void update() {
    var q = _quarks[runtimeType];
    if (q == null) return;

    if (q.autoCleanUnmountedStates) q.cleanUnmountedStates();
    q.update();
  }
}

class _quark<T> {
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
    var mountedStates = states.where((element) => element.mounted);
    for (var element in mountedStates) {
      element.setState(() {});
    }

    for (int i = 0; i < states.length; i++) {
      if (states[i].mounted) states[i].setState(() {});
    }
  }

  void addStateIfNotExists(State state) {
    var st = states.firstWhereOrNull((element) => element == state);
    if (st == null) states.add(state);
  }

  _quark({required this.impl, required this.states});
}
