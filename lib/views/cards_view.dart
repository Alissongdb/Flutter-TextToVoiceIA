// lib/views/cards_view.dart

import 'package:flutter/material.dart';

class CardsView extends StatelessWidget {
  final List<String> savedTexts;
  final Function(int) onDelete;
  final Function(int) onEdit; // Função para editar o card

  const CardsView({
    Key? key,
    required this.savedTexts,
    required this.onDelete,
    required this.onEdit, // Recebe a função de edição
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Textos Salvos'),
      ),
      body: ListView.builder(
        itemCount: savedTexts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Quando um card for tocado, chama a função de edição passando o índice
              onEdit(index);
              Navigator.pop(context, savedTexts[index]);
            },
            child: Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        savedTexts[index],
                        style: const TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Ao clicar no ícone de exclusão, chama a função de deleção
                        onDelete(index); // Deleta o card da lista
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
