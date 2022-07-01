# hydro

A simple state management & service container solution for Flutter.


### Usage
```dart
import 'package:hydro/hydro.dart';
```

```dart
// inherit Hydro
class SomeClass extends Hydro {
  
  String _name = "inital value";
  
  // getter
  String get name => _name;
  
  // setter
  void setName(String newName) {
    _name = newName;
    update(); // NOTE: `update()` is important to refresh the UI.
  }
  
}
```

```dart
// Adding to the service container
// If already been added, nothing will change.
Hydro.set(SomeClass());

// OR

// force replace an existing service, set `forceReplace: true`
Hydro.set(SomeClass(), forceReplace: true);
```

```dart
class _SomePageState extends State<SomePage> {
 // ...   
     
SomeClass? some_class = Hydro.get<SomeClass>(this);
// OR
SomeClass some_class = Hydro.mustGet<SomeClass>(this);

// NOTE: `get` & `mustGet` methods accept an argument of type `State`,
// it is required to refresh the UI when changes occur;
// You may as well leave it empty if UI updates are NOT needed.
// SomeClass? some_class = Hydro.get<SomeClass>();
```