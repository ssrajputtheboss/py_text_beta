## Examples

```dart
import 'package:py_text_beta/py_text_beta.dart';
//example with optional arguments
PyText('''
for i in range(10):
  print('Hello Dart!')
''',
fontSize: 15, padding : 0, theme: HighlightTheme.defaultDarkTheme(),
);// you can create your custom theme using HighlightTheme class
```