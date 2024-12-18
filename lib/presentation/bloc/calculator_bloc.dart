import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_expressions/math_expressions.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  String _input = '';
  String _result = '';

  CalculatorBloc() : super(InputState('')) {
    on<AppendInput>(_onAppendInput);
    on<CalculateResult>(_onCalculateResult);
    on<ClearInput>(_onClearInput);
    on<DeleteLastInput>(_onDeleteLastInput);
  }

  void _onAppendInput(AppendInput event, Emitter<CalculatorState> emit) {
    String value = event.value;

    // Replace special symbols
    if (value == 'π') value = pi.toString();
    if (value == 'e') value = e.toString();
    if (value == '√') value = 'sqrt';

    _input += value;
    emit(InputState(_input));
  }

  void _onCalculateResult(CalculateResult event, Emitter<CalculatorState> emit) {
    if (_input.isEmpty) {
    // Don't perform calculations if the input is empty
    return;
  }
    try {
      final parsedResult = _evaluateExpression(_input);
      _result = parsedResult.toString();
      emit(ResultState(_result));
    } catch (e) {
      emit(ErrorState('Invalid Expression'));
    }
  }

  void _onClearInput(ClearInput event, Emitter<CalculatorState> emit) {
    _input = '';
    emit(InputState(_input));
  }

  void _onDeleteLastInput(DeleteLastInput event, Emitter<CalculatorState> emit) {
    if (_input.isNotEmpty) {
      _input = _input.substring(0, _input.length - 1);
    }
    emit(InputState(_input));
  }

  double _evaluateExpression(String expression) {
    if (expression.isEmpty) {
    throw Exception('No input to evaluate');
  }
  
    try {
      // Handle degree conversions for trigonometric functions
      String parsedExpression = expression
          .replaceAllMapped(RegExp(r'sin\(([^)]+)\)'), (match) {
            final value = double.parse(match.group(1)!);
            return sin(value * pi / 180).toString();
          })
          .replaceAllMapped(RegExp(r'cos\(([^)]+)\)'), (match) {
            final value = double.parse(match.group(1)!);
            return cos(value * pi / 180).toString();
          })
          .replaceAllMapped(RegExp(r'tan\(([^)]+)\)'), (match) {
            final value = double.parse(match.group(1)!);
            return tan(value * pi / 180).toString();
          });

      // Evaluate the expression using math_expressions
      Parser parser = Parser();
      Expression exp = parser.parse(parsedExpression);
      ContextModel contextModel = ContextModel();
      return exp.evaluate(EvaluationType.REAL, contextModel);
    } catch (e) {
      throw Exception('Error evaluating expression');
    }
  }
}
