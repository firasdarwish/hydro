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

import 'package:flutter/material.dart';
import 'package:hydro/hydro.dart';

import 'some_class.dart';

class SomePage extends StatefulWidget {
  const SomePage({Key? key}) : super(key: key);

  @override
  State<SomePage> createState() => _SomePageState();
}

class _SomePageState extends State<SomePage> {
  late SomeClass someClass;

  @override
  void initState() {
    someClass = Hydro.mustGet<SomeClass>(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SomePage"),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              onChanged: (newValue) {
                someClass.setName(newValue);
              },
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),
            Text(
              someClass.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            ElevatedButton(
                onPressed: () {
                  var alert = StatefulBuilder(builder: (ctx, stateSetter) {
                    return AlertDialog(
                      title: const Text("Alert Dialog"),
                      content: Center(
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (newValue) {
                                someClass.setName(newValue);
                                stateSetter(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: "Name",
                              ),
                            ),
                            Text(
                              someClass.name,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  someClass.IncrementCounter();
                                },
                                child: const Text("Increment Counter")),
                          ],
                        ),
                      ),
                    );
                  });

                  showDialog(context: context, builder: (ctx) => alert);
                },
                child: const Text("Dialog"))
          ],
        ),
      ),
    );
  }
}
