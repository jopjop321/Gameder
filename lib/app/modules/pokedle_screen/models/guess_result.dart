import 'package:flutter/material.dart';

import '../controllers/pokemon.dart';
import '../theme/pokedle_theme.dart';

enum CellStatus { correct, partial, wrong }

enum ArrowDirection { up, down, none }

class AttributeResult {
  final CellStatus status;
  final String display;
  final ArrowDirection arrow;

  const AttributeResult({
    required this.status,
    required this.display,
    this.arrow = ArrowDirection.none,
  });

  Color get color {
    switch (status) {
      case CellStatus.correct:
        return kCorrectColor;
      case CellStatus.partial:
        return kPartialColor;
      case CellStatus.wrong:
        return kWrongColor;
    }
  }
}

class GuessResult {
  final Pokemon pokemon;
  final List<AttributeResult> attributes;
  final bool isWin;

  GuessResult({
    required this.pokemon,
    required this.attributes,
    required this.isWin,
  });

  factory GuessResult.evaluate(Pokemon guess, Pokemon answer) {
    final attributes = <AttributeResult>[
      AttributeResult(
        status: guess.id == answer.id ? CellStatus.correct : CellStatus.wrong,
        display: guess.name,
      ),
      _evaluateType1(guess, answer),
      _evaluateType2(guess, answer),
      _evaluateNumeric(
        guessValue: guess.evolutionStage,
        answerValue: answer.evolutionStage,
        display: guess.evolutionStage.toString(),
      ),
      AttributeResult(
        status: guess.fullyEvolved == answer.fullyEvolved
            ? CellStatus.correct
            : CellStatus.wrong,
        display: guess.fullyEvolved ? 'Yes' : 'No',
      ),
      AttributeResult(
        status: guess.color.toLowerCase() == answer.color.toLowerCase()
            ? CellStatus.correct
            : CellStatus.wrong,
        display: guess.color,
      ),
      AttributeResult(
        status: guess.habitat.toLowerCase() == answer.habitat.toLowerCase()
            ? CellStatus.correct
            : CellStatus.wrong,
        display: guess.habitat,
      ),
      _evaluateNumeric(
        guessValue: guess.generation,
        answerValue: answer.generation,
        display: guess.generation.toString(),
      ),
    ];

    return GuessResult(
      pokemon: guess,
      attributes: attributes,
      isWin: guess.id == answer.id,
    );
  }

  static AttributeResult _evaluateType1(Pokemon guess, Pokemon answer) {
    if (guess.type1.toLowerCase() == answer.type1.toLowerCase()) {
      return AttributeResult(status: CellStatus.correct, display: guess.type1);
    }
    if (answer.types.map((type) => type.toLowerCase()).contains(
          guess.type1.toLowerCase(),
        )) {
      return AttributeResult(status: CellStatus.partial, display: guess.type1);
    }
    return AttributeResult(status: CellStatus.wrong, display: guess.type1);
  }

  static AttributeResult _evaluateType2(Pokemon guess, Pokemon answer) {
    final guessType = guess.type2;
    final answerType = answer.type2;
    final display = guessType ?? '—';

    if (guessType == null && answerType == null) {
      return AttributeResult(status: CellStatus.correct, display: display);
    }
    if (guessType != null &&
        answerType != null &&
        guessType.toLowerCase() == answerType.toLowerCase()) {
      return AttributeResult(status: CellStatus.correct, display: display);
    }
    if (guessType != null &&
        answer.types
            .map((type) => type.toLowerCase())
            .contains(guessType.toLowerCase())) {
      return AttributeResult(status: CellStatus.partial, display: display);
    }
    return AttributeResult(status: CellStatus.wrong, display: display);
  }

  static AttributeResult _evaluateNumeric({
    required int guessValue,
    required int answerValue,
    required String display,
  }) {
    final difference = answerValue - guessValue;
    final arrow = difference > 0
        ? ArrowDirection.up
        : difference < 0
            ? ArrowDirection.down
            : ArrowDirection.none;
    final status = difference == 0
        ? CellStatus.correct
        : difference.abs() == 1
            ? CellStatus.partial
            : CellStatus.wrong;
    return AttributeResult(status: status, display: display, arrow: arrow);
  }
}
