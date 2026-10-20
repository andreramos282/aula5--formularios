import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cadastro_participante/main.dart';

void main() {
  group('Validações', () {
    test('e-mail', () {
      expect(validarEmail(''), 'Informe o e-mail.');
      expect(validarEmail('ana@email'), 'Informe um e-mail válido.');
      expect(validarEmail(' ana@email.com '), isNull);
    });

    test('nome', () {
      expect(validarNome('   '), 'Informe o nome.');
      expect(validarNome(' Al '), 'O nome deve ter pelo menos três caracteres.');
      expect(validarNome('Ana'), isNull);
    });

    test('telefone', () {
      expect(validarTelefone(''), 'Informe o telefone.');
      expect(validarTelefone('12981598561'), isNotNull);
      expect(validarTelefone('12-9815-98561'), isNotNull);
      expect(validarTelefone('12-98159-8561'), isNull);
    });

    test('CPF', () {
      expect(validarCpf(''), 'Informe o CPF.');
      expect(validarCpf('123.456.789-01'), isNotNull);
      expect(validarCpf('1234567890'), isNotNull);
      expect(validarCpf('12345678901'), isNull);
    });
  });

  testWidgets('mostra o resumo e volta com os campos preenchidos',
      (tester) async {
    await tester.pumpWidget(const CadastroParticipanteApp());

    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'ana@email.com');
    await tester.enterText(campos.at(1), 'Ana Souza');
    await tester.enterText(campos.at(2), '12-98159-8561');
    await tester.enterText(campos.at(3), '12345678901');

    await tester.tap(find.text('Exibir dados'));
    await tester.pumpAndSettle();

    expect(find.text('Resumo do cadastro'), findsOneWidget);
    expect(find.text('Nome: Ana Souza'), findsOneWidget);
    expect(find.text('CPF: 12345678901'), findsOneWidget);

    await tester.tap(find.text('Voltar para editar'));
    await tester.pumpAndSettle();

    expect(find.text('Ana Souza'), findsOneWidget);
  });

  testWidgets('não avança com dados inválidos e Limpar apaga tudo',
      (tester) async {
    await tester.pumpWidget(const CadastroParticipanteApp());

    await tester.tap(find.text('Exibir dados'));
    await tester.pump();

    expect(find.text('Informe o e-mail.'), findsOneWidget);
    expect(find.text('Resumo do cadastro'), findsNothing);

    await tester.enterText(find.byType(TextFormField).at(1), 'Ana');
    await tester.tap(find.text('Limpar'));
    await tester.pump();

    expect(find.text('Informe o e-mail.'), findsNothing);
    expect(find.text('Ana'), findsNothing);
  });
}
