# Aula 5: Formulários e validação

Exercício **Cadastro de participante** da disciplina Programação para Dispositivos Móveis (FATEC, Prof. Arley).

App Flutter com duas telas:

- **Cadastro:** `Form` com os campos E-mail, Nome, Telefone e CPF, cada um com sua função de validação.
- **Resumo:** recebe um objeto `Participante` pelo construtor e mostra os quatro dados. O botão **Voltar para editar** retorna ao formulário com os campos preenchidos.

| Campo | Validação | Teclado |
|---|---|---|
| E-mail | Obrigatório, estrutura básica `ana@email.com` | `TextInputType.emailAddress` |
| Nome | Obrigatório, mínimo 3 caracteres após `trim()` | `TextInputType.name` |
| Telefone | Obrigatório, formato `DD-DDDDD-DDDD` (indicado no `hintText`) | `TextInputType.phone` |
| CPF | Obrigatório, exatamente 11 dígitos, sem pontos ou traço | `TextInputType.number` |

- E-mail, Nome e Telefone usam `TextInputAction.next`. O CPF usa `TextInputAction.done` com `onFieldSubmitted`, que executa a mesma ação de **Exibir dados**.
- **Limpar:** `reset()` remove as mensagens, `clear()` apaga os textos e `unfocus()` retira o foco.
- `GlobalKey<FormState>` e os `TextEditingController` são atributos do estado e são descartados em `dispose()`.

## Como rodar

O repositório tem só o código (`lib/`, `test/` e `pubspec.yaml`). Para gerar as pastas das plataformas:

```bash
flutter create . --platforms web,android
flutter pub get
flutter run
flutter test   # testes das validações e da navegação
```
