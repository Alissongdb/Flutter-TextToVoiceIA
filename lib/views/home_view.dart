// lib/views/home_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cards_view.dart'; // A tela CardsView

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController _controller = TextEditingController();
  FlutterTts flutterTts = FlutterTts();
  List<String> savedTexts = [];
  int? _editingIndex; // Índice do card sendo editado (se houver)

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("pt-BR");
    flutterTts.setPitch(1);
    _loadSavedTexts();
  }

  // Função para falar o texto
  void _speak() async {
    String textToSpeak = _controller.text;
    if (textToSpeak.isNotEmpty) {
      await flutterTts.speak(textToSpeak);
    }
  }

  // Função para parar de falar
  void _stop() async {
    await flutterTts.stop();
  }

  // Função para salvar o conteúdo no SharedPreferences
  void _saveContent() async {
    String textToSave = _controller.text;
    if (textToSave.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (_editingIndex != null) {
        // Se estamos editando um card existente, atualizamos o texto no índice correspondente
        setState(() {
          savedTexts[_editingIndex!] = textToSave;
        });
      } else {
        // Caso contrário, criamos um novo card
        setState(() {
          savedTexts.add(textToSave);
        });
      }
      await prefs.setStringList('savedTexts', savedTexts);

      // Limpa o TextField e o índice de edição
      _controller.clear();
      setState(() {
        _editingIndex = null; // Reseta o índice de edição
      });

      // Navega para a tela CardsView para mostrar os cartões
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardsView(
            savedTexts: savedTexts,
            onDelete: _deleteCard,
            onEdit: _startEditing, // Passa a função de edição
          ),
        ),
      ).then((returnedText) {
        // Se o texto foi retornado da CardsView, preenche o TextField
        if (returnedText != null) {
          _controller.text = returnedText;
        }
      });
    }
  }

  // Função para carregar os textos salvos
  _loadSavedTexts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedTexts = prefs.getStringList('savedTexts') ?? [];
    });
  }

  // Função para excluir um card
  void _deleteCard(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedTexts.removeAt(index); // Remove o texto da lista
    });
    await prefs.setStringList(
        'savedTexts', savedTexts); // Atualiza a lista no SharedPreferences
  }

  // Função para iniciar a edição de um card
  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      _controller.text =
          savedTexts[index]; // Carrega o texto do card para o TextField
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons
              .folder_copy_outlined), // Ícone que fica à esquerda do título
          onPressed: () {
            // Ao clicar no ícone, abre a CardsView
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CardsView(
                  savedTexts: savedTexts,
                  onDelete: _deleteCard, // Passa a função de exclusão
                  onEdit: _startEditing, // Passa a função de edição
                ),
              ),
            ).then((returnedText) {
              // Ao retornar da CardsView, se houver texto retornado, coloca no TextField
              if (returnedText != null) {
                _controller.text = returnedText;
              }
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: _saveContent,
            icon: const Icon(Icons.save),
          ),
        ],
        title: const Text('Text To Voice IA'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: TextField(
                controller: _controller,
                maxLines: 28,
                decoration: InputDecoration(
                  hintText: 'Digite seu texto aqui',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _speak,
                child: const Text('Ouvir', style: TextStyle(fontSize: 20)),
              ),
              ElevatedButton(
                onPressed: _stop,
                child: const Text('Parar', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
