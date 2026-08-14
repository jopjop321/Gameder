import 'package:flutter_test/flutter_test.dart';

import 'package:gameder/app/modules/naruto/services/naruto_character_service.dart';
import 'package:gameder/app/modules/naruto/models/naruto_guess_result.dart';
import 'package:gameder/app/modules/aot/services/aot_character_service.dart';
import 'package:gameder/app/modules/aot/models/aot_guess_result.dart';
import 'package:gameder/app/modules/demonslayer/services/demonslayer_character_service.dart';
import 'package:gameder/app/modules/demonslayer/models/demonslayer_guess_result.dart';
import 'package:gameder/app/modules/mha/services/mha_character_service.dart';
import 'package:gameder/app/modules/mha/models/mha_guess_result.dart';
import 'package:gameder/app/modules/blackclover/services/blackclover_character_service.dart';
import 'package:gameder/app/modules/blackclover/models/blackclover_guess_result.dart';
import 'package:gameder/app/modules/bleach/services/bleach_character_service.dart';
import 'package:gameder/app/modules/bleach/models/bleach_guess_result.dart';
import 'package:gameder/app/modules/fairytail/services/fairytail_character_service.dart';
import 'package:gameder/app/modules/fairytail/models/fairytail_guess_result.dart';
import 'package:gameder/app/modules/hxh/services/hxh_character_service.dart';
import 'package:gameder/app/modules/hxh/models/hxh_guess_result.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Naruto data loads and self-guess evaluates as a win', () async {
    final characters = await NarutoCharacterService.loadCharacters();
    expect(characters, isNotEmpty);
    final answer = characters.first;
    final result = NarutoGuessResult.evaluate(answer, answer);
    expect(result.isWin, isTrue);
    expect(result.cells.every((c) => c.match == NarutoMatch.correct), isTrue);
  });

  test('AoT data loads and self-guess evaluates as a win', () async {
    final characters = await AotCharacterService.loadCharacters();
    expect(characters, isNotEmpty);
    final answer = characters.first;
    final result = AotGuessResult.evaluate(answer, answer);
    expect(result.isWin, isTrue);
    expect(result.cells.every((c) => c.match == AotMatch.correct), isTrue);
  });

  test('Demon Slayer data loads and self-guess evaluates as a win', () async {
    final characters = await DemonslayerCharacterService.loadCharacters();
    expect(characters, isNotEmpty);
    final answer = characters.first;
    final result = DemonslayerGuessResult.evaluate(answer, answer);
    expect(result.isWin, isTrue);
    expect(
      result.cells.every((c) => c.match == DemonslayerMatch.correct),
      isTrue,
    );
  });

  test('MHA data loads and self-guess evaluates as a win', () async {
    final characters = await MhaCharacterService.loadCharacters();
    expect(characters, isNotEmpty);
    final answer = characters.first;
    final result = MhaGuessResult.evaluate(answer, answer);
    expect(result.isWin, isTrue);
    expect(result.cells.every((c) => c.match == MhaMatch.correct), isTrue);
  });

  test('Black Clover data loads and self-guess evaluates as a win', () async {
    final characters = await BlackcloverCharacterService.loadCharacters();
    expect(characters, isNotEmpty);
    final answer = characters.first;
    final result = BlackcloverGuessResult.evaluate(answer, answer);
    expect(result.isWin, isTrue);
    expect(
      result.cells.every((c) => c.match == BlackcloverMatch.correct),
      isTrue,
    );
  });

  test('Bleach data loads and self-guess evaluates as a win', () async {
    final characters = await BleachCharacterService.loadCharacters();
    expect(characters, isNotEmpty);
    final answer = characters.first;
    final result = BleachGuessResult.evaluate(answer, answer);
    expect(result.isWin, isTrue);
    expect(result.cells.every((c) => c.match == BleachMatch.correct), isTrue);
  });

  test('Fairy Tail data loads and self-guess evaluates as a win', () async {
    final characters = await FairytailCharacterService.loadCharacters();
    expect(characters, isNotEmpty);
    final answer = characters.first;
    final result = FairytailGuessResult.evaluate(answer, answer);
    expect(result.isWin, isTrue);
    expect(
      result.cells.every((c) => c.match == FairytailMatch.correct),
      isTrue,
    );
  });

  test('Hunter x Hunter data loads and self-guess evaluates as a win', () async {
    final characters = await HxhCharacterService.loadCharacters();
    expect(characters, isNotEmpty);
    final answer = characters.first;
    final result = HxhGuessResult.evaluate(answer, answer);
    expect(result.isWin, isTrue);
    expect(result.cells.every((c) => c.match == HxhMatch.correct), isTrue);
  });
}
