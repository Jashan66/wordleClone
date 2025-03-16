import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle/guess_cubit.dart';
import 'package:wordle/word_repository.dart';
import 'package:wordle/guess_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GuessCubit(WordRepository())..fetchTargetWord(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(title: 'Wordle'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final guess = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: BlocListener<GuessCubit, GuessState>(
        listener: (context, state) {
          if (state.gameOver) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("YOU WIN!"),
                  content: Text(
                    "You guessed the word: ${state.targetWord} in ${state.guessCount} tries!",
                  ),
                  actions: [
                    TextButton(
                      child: Text("Play Again"),
                      onPressed:
                          () => {
                            context.read<GuessCubit>().resetGame(),
                            Navigator.of(context).pop(),
                          },
                    ),
                  ],
                );
              },
            );
          }
        },
        child: BlocBuilder<GuessCubit, GuessState>(
          builder: (context, state) {
            if (state.guessCount > 5) {
              return Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(40),
                      child: Text(
                        "You Lost, the word was: ${state.targetWord}",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => {context.read<GuessCubit>().resetGame()},
                      child: Text("Play Again ?"),
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 40),
                    child: Column(
                      children: [
                        state.guessedChars.isNotEmpty
                            ? Text("Guessed Letters")
                            : SizedBox(),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children:
                                  state.guessedChars.map((char) {
                                    return Container(
                                      width: 30,
                                      height: 30,
                                      padding: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          char,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            state.guesses
                                .map((guess) => GuessLayout(guess: guess))
                                .toList(),
                      ),

                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: guess,
                          decoration: InputDecoration(
                            hintText: "Enter Your Guess",
                          ),
                        ),
                      ),

                      state.error
                          ? Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              state.errorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          : SizedBox(),

                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: ElevatedButton(
                          onPressed:
                              () => {
                                context.read<GuessCubit>().checkWord(
                                  guess.text,
                                ),
                                guess.clear(),
                              },
                          child: Text("Guess"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
