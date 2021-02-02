import 'package:flutter/cupertino.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

TextDirection direction = translator.currentLanguage=='en'? TextDirection.ltr:TextDirection.rtl;

tr(String word){
  return translator.translate(word);
}