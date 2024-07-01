import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CocktailSelectionPage extends StatefulWidget {
  @override
  _CocktailSelectionPageState createState() => _CocktailSelectionPageState();
}

class _CocktailSelectionPageState extends State<CocktailSelectionPage> {
  List<String> selectedAlcohol = ["Вино красное", "Вино белое", "Вино розовое"];
  List<String> selectedIngredients = ["Лед", "Лимон"];
  List<String> selectedNonAlcoholic = ["Тоник", "Кока-кола", "Спрайт"];

  final List<String> alcoholTypes = ["Вино", "Водка", "Виски", "Шампанское"];
  final List<String> wineTypes = [
    "Вино красное",
    "Вино белое",
    "Вино розовое",
    "Вино десертное"
  ];
  final List<String> nonAlcoholicTypes = [
    "Тоник",
    "Кока-кола",
    "Спрайт",
    "Фанта"
  ];
  final List<String> productTypes = ["Лед", "Лимон", "Сахар", "Мята"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Подбор коктейля'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepIndicator(),
              SizedBox(height: 20),
              _buildSelectedChips(selectedAlcohol),
              _buildSelectedChips(selectedIngredients),
              SizedBox(height: 20),
              _buildExpansionPanelList(),
              SizedBox(height: 20),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStep("Алкоголь", isActive: true),
        _buildStep("Доп. ингредиенты"),
        _buildStep("Подбор"),
      ],
    );
  }

  Widget _buildStep(String label, {bool isActive = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: isActive ? Colors.green : Colors.grey,
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildSelectedChips(List<String> selectedItems) {
    return Wrap(
      spacing: 8.0,
      children: selectedItems.map((item) {
        return Chip(
          label: Text(item),
          onDeleted: () {
            setState(() {
              selectedItems.remove(item);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildExpansionPanelList() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          if (index == 0) {
            // Alcohol section
            selectedAlcohol = selectedAlcohol;
          } else if (index == 1) {
            // Non-alcoholic section
            selectedNonAlcoholic = selectedNonAlcoholic;
          }
        });
      },
      children: [
        _buildExpansionPanel(
            "Выберите основу коктейля", selectedAlcohol, wineTypes),
        _buildExpansionPanel("Дополнительные ингредиенты", selectedNonAlcoholic,
            nonAlcoholicTypes),
      ],
    );
  }

  ExpansionPanel _buildExpansionPanel(
      String header, List<String> selectedItems, List<String> items) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(header),
          subtitle: Text("(${selectedItems.length} выбрано)"),
        );
      },
      body: Column(
        children: items.map((item) {
          return CheckboxListTile(
            title: Text(item),
            value: selectedItems.contains(item),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedItems.add(item);
                } else {
                  selectedItems.remove(item);
                }
              });
            },
          );
        }).toList(),
      ),
      isExpanded: selectedItems.isNotEmpty,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: Text('Отмена', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: Text('Далее'),
        ),
      ],
    );
  }
}
