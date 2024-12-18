import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/calculator_bloc.dart';
import '../bloc/calculator_event.dart';
import '../bloc/calculator_state.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalculatorBloc(),
      child: const CalculatorView(),
    );
  }
}

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  bool isDarkMode = true;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final calculatorBloc = BlocProvider.of<CalculatorBloc>(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
        backgroundColor: isDarkMode ? Colors.black : Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Display
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(16),
              color: isDarkMode ? Colors.black : Colors.grey[200],
              child: BlocBuilder<CalculatorBloc, CalculatorState>(
                builder: (context, state) {
                  if (state is InputState) {
                    return Text(
                      state.input,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else if (state is ResultState) {
                    return Text(
                      state.result,
                      style: TextStyle(
                        color: isDarkMode ? Colors.green : Colors.blueAccent,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else if (state is ErrorState) {
                    return Text(
                      state.message,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          // Buttons Grid
          GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // First Row: π, e, ln, log, Dark/Light Mode Toggle
              ...['π', 'e', 'ln', 'log']
                  .map((label) => CalculatorButton(
                        label: label,
                        onPressed: () => calculatorBloc.add(AppendInput(label)),
                        isDarkMode: isDarkMode,
                      )),
              CalculatorButton(
                label: isDarkMode ? '🌙' : '☀️',
                onPressed: toggleTheme,
                isDarkMode: isDarkMode,
              ),
              // Second Row: sin, cos, tan, (, ), 7, 8, 9
              ...['sin', 'cos', 'tan', '(', ')', '7', '8', '9']
                  .map((label) => CalculatorButton(
                        label: label,
                        onPressed: () => calculatorBloc.add(AppendInput(label)),
                        isDarkMode: isDarkMode,
                      )),
              // Third Row: DEL, AC, 4, 5, 6, *, /
              ...['DEL', 'AC', '4', '5', '6', '*', '/']
                  .map((label) => CalculatorButton(
                        label: label,
                        onPressed: () {
                          if (label == 'DEL') {
                            calculatorBloc.add(DeleteLastInput());
                          } else if (label == 'AC') {
                            calculatorBloc.add(ClearInput());
                          } else {
                            calculatorBloc.add(AppendInput(label));
                          }
                        },
                        isDarkMode: isDarkMode,
                      )),
              // Fourth Row: 1, 2, 3, +, -, 0, ., ^, √
              ...['1', '2', '3', '+', '-', '0', '.', '^', '√']
                  .map((label) => CalculatorButton(
                        label: label,
                        onPressed: () => calculatorBloc.add(AppendInput(label)),
                        isDarkMode: isDarkMode,
                      )),
              // Equals Button
              CalculatorButton(
                label: '=',
                onPressed: () => calculatorBloc.add(CalculateResult()),
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isDarkMode;

  const CalculatorButton({
    required this.label,
    required this.onPressed,
    required this.isDarkMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
