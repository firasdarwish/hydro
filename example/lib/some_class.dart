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

import 'package:hydro/hydro.dart';

class SomeClass extends Hydro {
  String _name = "Firas";
  int _counter = 0;

  String get name => _name;

  int get counter => _counter;

  void setName(String newName) {
    _name = newName;
    update();
  }

  void incrementCounter() {
    _counter = _counter + 1;
    update();
  }
}
