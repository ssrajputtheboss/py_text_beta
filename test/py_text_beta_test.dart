import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:py_text_beta/py_text_beta.dart';

void main() {
 PyText('''
 x='hello'
 y='world'
 print(x,y,end=" ")''');
}
