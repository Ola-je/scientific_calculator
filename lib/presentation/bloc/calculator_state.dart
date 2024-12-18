abstract class CalculatorState {}

class InputState extends CalculatorState {
  final String input;

  InputState(this.input);
}

class ResultState extends CalculatorState {
  final String result;

  ResultState(this.result);
}

class ErrorState extends CalculatorState {
  final String message;

  ErrorState(this.message);
}
