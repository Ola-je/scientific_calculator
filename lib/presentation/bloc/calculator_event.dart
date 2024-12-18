abstract class CalculatorEvent {}

class AppendInput extends CalculatorEvent {
  final String value;

  AppendInput(this.value);
}

class ClearInput extends CalculatorEvent {}
class CalculateResult extends CalculatorEvent {}
class DeleteLastInput extends CalculatorEvent {} 