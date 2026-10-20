import 'package:flutter/material.dart';

void main() {
  runApp(const CadastroParticipanteApp());
}

class CadastroParticipanteApp extends StatelessWidget {
  const CadastroParticipanteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de participante',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const TelaCadastro(),
    );
  }
}

// Representa os dados preenchidos no formulário.
// Todos os atributos são imutáveis (final).
class Participante {
  final String email;
  final String nome;
  final String telefone;
  final String cpf;

  const Participante({
    required this.email,
    required this.nome,
    required this.telefone,
    required this.cpf,
  });
}

// Funções de validação.
// Cada uma retorna uma mensagem quando o valor é inválido e null quando é válido.

String? validarEmail(String? valor) {
  final email = valor?.trim() ?? '';

  if (email.isEmpty) {
    return 'Informe o e-mail.';
  }

  // Verificação simplificada: texto@texto.texto, sem espaços.
  final formato = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  if (!formato.hasMatch(email)) {
    return 'Informe um e-mail válido.';
  }

  return null;
}

String? validarNome(String? valor) {
  final nome = valor?.trim() ?? '';

  if (nome.isEmpty) {
    return 'Informe o nome.';
  }

  if (nome.length < 3) {
    return 'O nome deve ter pelo menos três caracteres.';
  }

  return null;
}

String? validarTelefone(String? valor) {
  final telefone = valor?.trim() ?? '';

  if (telefone.isEmpty) {
    return 'Informe o telefone.';
  }

  // Formato DD-DDDDD-DDDD, com os separadores digitados pelo usuário.
  final formato = RegExp(r'^\d{2}-\d{5}-\d{4}$');

  if (!formato.hasMatch(telefone)) {
    return 'Informe o telefone no formato DD-DDDDD-DDDD.';
  }

  return null;
}

String? validarCpf(String? valor) {
  final cpf = valor?.trim() ?? '';

  if (cpf.isEmpty) {
    return 'Informe o CPF.';
  }

  // Exatamente onze dígitos, sem pontos ou traço.
  // Os dígitos verificadores não são conferidos.
  final formato = RegExp(r'^\d{11}$');

  if (!formato.hasMatch(cpf)) {
    return 'O CPF deve conter exatamente 11 dígitos, sem pontos ou traço.';
  }

  return null;
}

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  // Chave e controladores são atributos do estado, e não são criados no build().
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();

  void _exibirDados() {
    final formularioValido = _formKey.currentState!.validate();

    if (!formularioValido) {
      return;
    }

    // Os dados são lidos pelos controladores, com trim(), depois da validação.
    final participante = Participante(
      email: _emailController.text.trim(),
      nome: _nomeController.text.trim(),
      telefone: _telefoneController.text.trim(),
      cpf: _cpfController.text.trim(),
    );

    FocusScope.of(context).unfocus();

    // push mantém a tela de cadastro na pilha; ao voltar, os campos continuam preenchidos.
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => TelaResumo(participante: participante),
      ),
    );
  }

  void _limpar() {
    // reset() remove as mensagens de validação.
    _formKey.currentState!.reset();

    // clear() apaga o texto de cada campo.
    _emailController.clear();
    _nomeController.clear();
    _telefoneController.clear();
    _cpfController.clear();

    // unfocus() retira o foco do campo ativo e fecha o teclado.
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nomeController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de participante'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Informe os dados do participante.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'Ex.: ana@email.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                validator: validarEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  hintText: 'Ex.: Ana Souza',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: validarNome,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: 'DD-DDDDD-DDDD',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: validarTelefone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: 'Somente os 11 dígitos',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: validarCpf,
                // Mesma operação do botão Exibir dados.
                onFieldSubmitted: (_) => _exibirDados(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _exibirDados,
                child: const Text('Exibir dados'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _limpar,
                child: const Text('Limpar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TelaResumo extends StatelessWidget {
  final Participante participante;

  const TelaResumo({
    super.key,
    required this.participante,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo do cadastro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Dados do participante',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text('E-mail: ${participante.email}'),
            const SizedBox(height: 12),
            Text('Nome: ${participante.nome}'),
            const SizedBox(height: 12),
            Text('Telefone: ${participante.telefone}'),
            const SizedBox(height: 12),
            Text('CPF: ${participante.cpf}'),
            const SizedBox(height: 24),
            ElevatedButton(
              // pop volta ao formulário, que continua com os campos preenchidos.
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar para editar'),
            ),
          ],
        ),
      ),
    );
  }
}
