import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  dynamic text = '0';
  double numOne = 0;
  double numTwo = 0;
  dynamic result = '';
  dynamic finalResult = '';
  dynamic opr = '';
  dynamic preOpr = '';

  void calculation(String btnText) {
    if (btnText == 'AC') {
      text = '0';
      numOne = 0;
      numTwo = 0;
      result = '';
      finalResult = '0';
      opr = '';
      preOpr = '';
    } else if (opr == '=' && btnText == '=') {
      if (preOpr == '+') {
        finalResult = add();
      } else if (preOpr == '-') {
        finalResult = sub();
      } else if (preOpr == 'x') {
        finalResult = mul();
      } else if (preOpr == '/') {
        finalResult = div();
      }
    } else if (btnText == '+' ||
        btnText == '-' ||
        btnText == 'x' ||
        btnText == '/' ||
        btnText == '=') {
      if (result.isNotEmpty) {
        numTwo = double.tryParse(result) ?? 0;
      }

      if (opr.isNotEmpty) {
        if (opr == '+') {
          finalResult = add();
        } else if (opr == '-') {
          finalResult = sub();
        } else if (opr == 'x') {
          finalResult = mul();
        } else if (opr == '/') {
          finalResult = div();
        }
      } else {
        // Set numOne to the current number when the first operator is pressed
        numOne = numTwo;
      }

      preOpr = opr;
      opr = btnText;
      result = '';
    } else if (btnText == '%') {
      if (result.isNotEmpty) {
        double percentage = double.tryParse(result) ?? 0;
        result = (numOne * (percentage / 100)).toString();
        finalResult = doesContainDecimal(result);
      }
    } else if (btnText == '.') {
      if (!result.contains('.')) {
        result += '.';
      }
      finalResult = result;
    } else if (btnText == '<') {
      if (result.isNotEmpty) {
        result =
            result.substring(0, result.length - 1); // Last digit remove karna
        if (result.isEmpty) {
          result = '0'; // Agar sab remove ho jaye toh '0' dikhana
        }
      }
      finalResult = result;
    } else {
      result += btnText;
      finalResult = result;
    }

    setState(() {
      text = finalResult.toString();
    });
  }

  String add() {
    result = (numOne + numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String sub() {
    result = (numOne - numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String mul() {
    result = (numOne * numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String div() {
    result = (numOne / numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  String doesContainDecimal(dynamic result) {
    // Round to 8 decimal places to avoid floating-point errors
    double rounded = double.parse(result.toString()).toDouble();
    String resultStr =
        rounded.toStringAsFixed(8); // Adjust decimal places as needed

    // Split into integer and decimal parts
    List<String> parts = resultStr.split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];

    // Trim trailing zeros
    decimalPart = decimalPart.replaceAll(RegExp(r"0+$"), '');

    // Reconstruct the result
    if (decimalPart.isEmpty) {
      return integerPart; // e.g., "5.000" → "5"
    } else {
      return '$integerPart.$decimalPart'; // e.g., "0.82500000" → "0.825"
    }
  }

  Widget calcButton(String btntxt, Color btncolor, Color txtcolor) {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          calculation(btntxt);
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: btncolor,
          padding: const EdgeInsets.all(15),
        ),
        child: Text(
          btntxt,
          style: TextStyle(
            fontSize: 20,
            color: txtcolor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Calculator',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.cancel,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30, bottom: 20, left: 30, right: 40),
                    child: Text(
                      '$text',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('AC', Colors.grey, Colors.black),
                  calcButton('<', Colors.grey, Colors.black),
                  calcButton('%', Colors.grey, Colors.black),
                  calcButton('/', Constant.colorPurple, Colors.white),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('7', Colors.grey[850]!, Colors.white),
                  calcButton('8', Colors.grey[850]!, Colors.white),
                  calcButton('9', Colors.grey[850]!, Colors.white),
                  calcButton('x', Constant.colorPurple, Colors.white),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('4', Colors.grey[850]!, Colors.white),
                  calcButton('5', Colors.grey[850]!, Colors.white),
                  calcButton('6', Colors.grey[850]!, Colors.white),
                  calcButton('-', Constant.colorPurple, Colors.white),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcButton('1', Colors.grey[850]!, Colors.white),
                  calcButton('2', Colors.grey[850]!, Colors.white),
                  calcButton('3', Colors.grey[850]!, Colors.white),
                  calcButton('+', Constant.colorPurple, Colors.white),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      calculation('0');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.grey[850],
                      padding: const EdgeInsets.fromLTRB(34, 15, 110, 15),
                    ),
                    child: const Text(
                      '0',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                  calcButton('.', Colors.grey[850]!, Colors.white),
                  calcButton('=', Constant.colorPurple, Colors.white),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
