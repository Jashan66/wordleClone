import 'package:flutter/material.dart';

class GuessLayout extends StatefulWidget {
  final List guess;

  const GuessLayout({Key? key, required this.guess}) : super(key: key);
  @override
  State<GuessLayout> createState() => _MyGuessLayout();
}

class _MyGuessLayout extends State<GuessLayout> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            widget.guess.map((subArray) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: subArray[1],
                  ),
                  child: Center(
                    child: Text(
                      subArray[0],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
