import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iPhone Box Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _operator = '';
  double _firstNumber = 0;
  bool _shouldReset = false;

  void _onPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _display = '0';
        _operator = '';
        _firstNumber = 0;
      } else if (value == '+/-') {
        if (_display != '0') {
          _display = _display.startsWith('-')
              ? _display.substring(1)
              : '-$_display';
        }
      } else if (value == '%') {
        double num = double.tryParse(_display) ?? 0;
        _display = (num / 100).toString();
      } else if (value == '+' || value == '-' || value == '×' || value == '÷') {
        _firstNumber = double.tryParse(_display) ?? 0;
        _operator = value;
        _shouldReset = true;
      } else if (value == '=') {
        double secondNumber = double.tryParse(_display) ?? 0;
        double result = 0;

        switch (_operator) {
          case '+':
            result = _firstNumber + secondNumber;
            break;
          case '-':
            result = _firstNumber - secondNumber;
            break;
          case '×':
            result = _firstNumber * secondNumber;
            break;
          case '÷':
            result =
                secondNumber != 0 ? _firstNumber / secondNumber : double.nan;
            break;
        }

        _display = result.isNaN ? 'Error' : _formatResult(result);
        _operator = '';
        _shouldReset = true;
      } else {
        if (_shouldReset) {
          _display = value;
          _shouldReset = false;
        } else {
          if (_display == '0') {
            _display = value;
          } else {
            _display += value;
          }
        }
      }
    });
  }

  String _formatResult(double result) {
    if (result == result.roundToDouble()) {
      return result.toInt().toString();
    } else {
      return result.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> buttons = [
      'AC', '+/-', '%', '÷',
      '7', '8', '9', '×',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '0', '.', '='
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFE5B4), // 🌤️ light orange background
      body: Center(
        child: Container(
          width: 350,
          height: 550,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF000000), // inner calculator box (black)
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.6),
                blurRadius: 15,
                spreadRadius: 3,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(10),
                child: Text(
                  _display,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 10),
              _buildButtonGrid(buttons),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonGrid(List<String> buttons) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: buttons.map((btn) => _buildCalcButton(btn)).toList(),
    );
  }

  Widget _buildCalcButton(String text) {
    Color bgColor;
    Color textColor = Colors.white;

    if (text == 'AC' || text == '+/-' || text == '%') {
      bgColor = Colors.grey.shade400;
      textColor = Colors.black;
    } else if (text == '÷' || text == '×' || text == '-' || text == '+' || text == '=') {
      bgColor = Colors.orange;
    } else {
      bgColor = Colors.grey.shade800;
    }

    double buttonWidth = (text == '0') ? 150 : 70;

    return SizedBox(
      width: buttonWidth,
      height: 70,
      child: ElevatedButton(
        onPressed: () => _onPressed(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          padding: EdgeInsets.zero,
          elevation: 4,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
