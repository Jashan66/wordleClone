import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:wordle/word_repository.dart';

class GuessState {
  final int guessCount;
  final List<List<dynamic>> guesses;
  final bool error;
  final String errorMessage;
  final bool gameOver;
  final String targetWord;
  final Set<String> guessedChars;

  GuessState({
    required this.guesses,
    this.guessCount = 0,
    this.error = false,
    this.errorMessage = "",
    this.gameOver = false,
    required this.targetWord,
    required this.guessedChars,
  });
  factory GuessState.initial() {
    return GuessState(guesses: [], guessedChars: <String>{}, targetWord: "");
  }
  GuessState copyWith({
    List<List<dynamic>>? guesses,
    int? guessCount,
    Set<String>? guessedChars,
    bool? error,
    String? errorMessage,
    bool? gameOver,
    String? targetWord,
  }) {
    return GuessState(
      guesses: guesses ?? this.guesses,
      guessCount: guessCount ?? this.guessCount,
      guessedChars: guessedChars ?? this.guessedChars,
      error: error ?? this.error,
      errorMessage: errorMessage ?? this.errorMessage,
      gameOver: gameOver ?? this.gameOver,
      targetWord: targetWord ?? this.targetWord,
    );
  }
}

class GuessCubit extends Cubit<GuessState> {
  final WordRepository wordRepository;

  GuessCubit(this.wordRepository) : super(GuessState.initial());

  Future<void> fetchTargetWord() async {
    try {
      final word = await wordRepository.getWord();
      print(word);
      emit(
        state.copyWith(
          targetWord: word.toUpperCase(),
          guessCount: 0,
          guesses: [],
          guessedChars: {},
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: true, errorMessage: "Failed to fetch word"));
    }
  }

  void checkWord(String word) {
    final List curGuess = [];
    word = word.toUpperCase();
    final Set<String> updatedGuessedChars = Set.from(state.guessedChars);

    if (word.length != 5) {
      emit(
        GuessState(
          guesses: [...state.guesses],
          guessCount: state.guessCount,
          error: true,
          errorMessage: "Guess must be exactly 5 characters",
          targetWord: state.targetWord,
          guessedChars: updatedGuessedChars,
        ),
      );
    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(word)) {
      //if word is not just characters
      emit(
        GuessState(
          guesses: [...state.guesses],
          guessCount: state.guessCount,
          error: true,
          errorMessage: "Enter a valid guess only characters are allowed",
          targetWord: state.targetWord,
          guessedChars: updatedGuessedChars,
        ),
      );
    } else {
      int count = 0;
      for (int i = 0; i < state.targetWord.length; i++) {
        if (state.targetWord[i] == word[i]) {
          count += 1;
          curGuess.add([word[i], Colors.green]);
        } else if (state.targetWord.contains(word[i])) {
          curGuess.add([word[i], Colors.yellow]);
        } else if (!state.targetWord.contains(word[i])) {
          updatedGuessedChars.add(word[i]);
          curGuess.add([word[i], Colors.grey]);
        }
      }
      if (count == 5) {
        emit(
          GuessState(
            guesses: [...state.guesses, curGuess],
            guessCount: state.guessCount + 1,
            error: false,
            gameOver: true,
            targetWord: state.targetWord,
            guessedChars: updatedGuessedChars,
          ),
        );
      } else {
        emit(
          GuessState(
            guesses: [...state.guesses, curGuess],
            guessCount: state.guessCount + 1,
            error: false,
            targetWord: state.targetWord,
            guessedChars: updatedGuessedChars,
          ),
        );
      }
    }
  }

  void resetGame() {
    emit(GuessState.initial());
    fetchTargetWord();
  }
}
