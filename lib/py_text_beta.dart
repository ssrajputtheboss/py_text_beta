library py_text_beta;
import 'package:flutter/material.dart';

class HighlightTheme {
  Color _bgColor;
  TextStyle _keywordStyle = TextStyle(color: Colors.deepPurple),
      _commentStyle = TextStyle(color:Colors.grey,fontStyle: FontStyle.italic),
      _multiLineCommentStyle = TextStyle(color:Colors.grey,fontStyle: FontStyle.italic),
      _specialIdentifiersStyle = TextStyle(color: Colors.red),
      _numberConstantStyle = TextStyle(color: Colors.white),
      _stringConstantStyle = TextStyle(color: Colors.green),
      _operatorStyle = TextStyle(color:Colors.pinkAccent),
      _specialCharacterStyle = TextStyle(color:Colors.yellow),
      _identifierStyle = TextStyle(color: Colors.lightBlueAccent);
  HighlightTheme({
    TextStyle keywordStyle ,
    TextStyle commentStyle,
    TextStyle multilineCommentStyle,
    TextStyle specialIdentifiersStyle,
    TextStyle numberConstantStyle,
    TextStyle stringConstantStyle,
    TextStyle operatorStyle,
    TextStyle specialCharacterStyle,
    TextStyle identifierStyle,
    Color bgColor = Colors.black87
  }){
    _keywordStyle  = keywordStyle==null ? _keywordStyle: keywordStyle;
    _commentStyle = commentStyle==null ? _commentStyle:commentStyle;
    _multiLineCommentStyle = multilineCommentStyle==null? _multiLineCommentStyle:multilineCommentStyle;
    _specialIdentifiersStyle = specialIdentifiersStyle==null?_specialIdentifiersStyle:specialIdentifiersStyle;
    _numberConstantStyle = numberConstantStyle==null?_numberConstantStyle:numberConstantStyle;
    _stringConstantStyle = stringConstantStyle==null?_stringConstantStyle:stringConstantStyle;
    _operatorStyle = operatorStyle==null?_operatorStyle:operatorStyle;
    _specialCharacterStyle = specialCharacterStyle==null?_specialCharacterStyle:specialCharacterStyle;
    _identifierStyle = identifierStyle==null?_identifierStyle:identifierStyle;
    _bgColor = bgColor;
  }
  Color backgroundColor(){
    return _bgColor;
  }
  TextStyle keyword(){
    return _keywordStyle;
  }
  TextStyle comment(){
    return _commentStyle;
  }
  TextStyle multilineComment(){
    return _multiLineCommentStyle;
  }
  TextStyle specialIdentifier(){
    return _specialIdentifiersStyle;
  }
  TextStyle numberConstant(){
    return _numberConstantStyle;
  }
  TextStyle stringConstant(){
    return _stringConstantStyle;
  }
  TextStyle operator(){
    return _operatorStyle;
  }
  TextStyle specialCharacter(){
    return _specialCharacterStyle;
  }
  TextStyle identifier(){
    return _identifierStyle;
  }

  static HighlightTheme defaultDarkTheme(){
    return HighlightTheme();
  }
}

class PyText extends StatelessWidget{
  String _text;
  double _fontSize,_padding;
  HighlightTheme _theme = HighlightTheme.defaultDarkTheme();
  PyText(String text,{double fontSize=20,
    double padding = 10,
    HighlightTheme theme,
  }){
    _fontSize = fontSize;
    _padding = padding;
    _theme = theme == null ? _theme  : theme;
    _text = text.replaceAll('`', '').replaceAll('\t', '    ');
  }

  TextStyle getTextStyle(String token){
    var keywords = [
      'False',	'await',	'else',	'import',	'pass',
      'None',	'break',	'except',	'in'	,'raise',
      'True',	'class',	'finally',	'is',	'return',
      'and',	'continue',	'for',	'lambda',	'try',
      'as',	'def',	'from',	'nonlocal'	,'while',
      'assert',	'del',	'global',	'not',	'with',
      'async'	,'elif'	,'if',	'or'	,'yield',
    ];
    var defaultFunctions = ["abs", "all", "any", "bin", "bool", "bytearray", "callable", "chr",
      "classmethod", "compile", "complex", "delattr", "dict", "dir", "divmod",
      "enumerate", "eval", "filter", "float", "format", "frozenset",
      "getattr", "globals", "hasattr", "hash", "help", "hex", "id",
      "input", "int", "isinstance", "issubclass", "iter", "len",
      "list", "locals", "map", "max", "memoryview", "min", "next",
      "object", "oct", "open", "ord", "pow", "property", "range",
      "repr", "reversed", "round", "set", "setattr", "slice",
      "sorted", "staticmethod", "str", "sum", "super", "tuple",
      "type", "vars", "zip", "__import__", "NotImplemented",
      "Ellipsis", "__debug__"];
    var operators = ['+','-','*','/','%','^','&','|','~','=','<','>','**','<=','>=','+=','-=','*=','/=','%=','**='];
    var re = new RegExp(r'\w+');
    if(re.stringMatch(token) == token){
      if (keywords.contains(token)) {
        return _theme.keyword();
      } else if (defaultFunctions.contains(token))
        return _theme.specialIdentifier();
      else if((new RegExp(r'\d+')).stringMatch(token) == token)
        return _theme.numberConstant();
      return _theme.identifier();
    }else{
      if((new RegExp(r'#.*')).stringMatch(token) == token)
        return _theme.comment();
      else if((new RegExp(r'''('(.|\n)*')|("(.|\n)*")''')).stringMatch(token) == token)
        return _theme.stringConstant();
      else if(operators.contains(token.trim()))
        return _theme.operator();
      return _theme.specialCharacter();
    }
  }

  createSpans(String text){
    var spans = <TextSpan>[];
    var re1 = r'"(\\\n|\\"|[^"\n])*"';
    var re2 = r"'(\\\n|(\\')|[^'\n])*'";
    var re3 = r'"""(.|\n)*?"""';
    var re4 = r"'''(.|\n)*?'''";
    var rs = re1+'|'+re2;
    var rc = re3 + '|' + re4;
    var lst = [];
    var r = new RegExp(rc + '|' + rs + '|' + r'#.*');
    r.allMatches(text).forEach((i) {
      text = text.replaceFirst(i.group(0), '`');
      lst.add(i.group(0));
    });
    var  re = new RegExp(r'(`)|([^`%\+\=\-\*/\&\^\|~\w])+|((\w)+)|[\s%\+\=\-\*/\&\^\|~]+');
    int j=0;
    var lastToken = '';
    re.allMatches(text).forEach((i) {
      if(i.group(0).contains('`')){
        var x = i.group(0).replaceFirst('`', lst[j]);
        if(!lastToken.contains(new RegExp(r'\+|=|\*')) && (new RegExp(r'"""(.|\n)*"""'+'|'+r"'''(.|\n)*'''").hasMatch(lst[j]))){
          //it is a multiline comment
          spans.add(TextSpan(text: x,style: _theme.multilineComment()));
        }else
          spans.add(TextSpan(text: x,style: getTextStyle(lst[j])));
        j++;
      }else {
        spans.add(TextSpan(text: i.group(0), style: getTextStyle(i.group(0))));
      }
      lastToken = i.group(0);
    });
    return  spans;
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          color: _theme.backgroundColor(),
        ),
        child: RichText(
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
              text: '',
              style: TextStyle(fontSize: _fontSize),
              children: createSpans(_text)
          ),
        )
    );
  }

}
