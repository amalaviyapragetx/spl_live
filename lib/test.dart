import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AutocompletePage(),
    );
  }
}

class AutocompletePage extends StatefulWidget {
  @override
  _AutocompletePageState createState() => _AutocompletePageState();
}

class _AutocompletePageState extends State<AutocompletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RawAutocomplete Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RawAutocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            // Filter the recommendation list based on the current user input
            final List<String> filteredOptions = recommendations
                .where((option) => option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()))
                .toList();

            return filteredOptions;
          },
          onSelected: (String selection) {
            setState(() {
              selectedValue = selection;
            });
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Type and get recommendations',
                border: OutlineInputBorder(),
              ),
            );
          },
          optionsViewBuilder: (BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: Container(
                  width: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return ListTile(
                        title: Text(option),
                        onTap: () {
                          onSelected(option);
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
