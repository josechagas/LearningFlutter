
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatHelper{

  static String currencyFormat(double value,{String name}) {
    return NumberFormat.simpleCurrency(name: name).format(value);
  }

  static String percentFormat(double value) {
    return NumberFormat.decimalPercentPattern(
      decimalDigits: 2,
    ).format(value.abs() / 100.0);
  }

  static TextEditingValue currencyTFFormatter(TextEditingValue oldValue,
      TextEditingValue newValue){
    var currentNumber = newValue.text.replaceAll(RegExp(r'\D'), '');
    if(currentNumber.length > 3){
      if(currentNumber.substring(0,1) == "0"){
        currentNumber = currentNumber.substring(1);
      }
    }
    var doubleValue = double.tryParse(currentNumber);
    if(doubleValue != null){
      var resultText = currencyFormat(doubleValue);
      if(doubleValue >= 1){
        resultText = currencyFormat(doubleValue/100.0);
      }
      return TextEditingValue(
        text: resultText,
        selection: TextSelection.fromPosition(
          TextPosition(affinity: TextAffinity.downstream, offset: resultText.length),
        ),
      );
    }
    else{
      return oldValue;
    }
  }
}