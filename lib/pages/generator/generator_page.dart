import 'package:flutter/material.dart';
import '../../components/floating_add_button.dart';
import '../../components/search_input.dart';
import 'generator_list.dart';
import 'add_generator.dart';

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> generators = [
      {"name": "CAT - 8KS1", "location": "Warehouse A", "remaining": "600 L"},
      {"name": "FG P200-3", "location": "Site B", "remaining": "420 L"},
      {"name": "GTR 4493", "location": "Factory Zone", "remaining": "300 L"},
      {"name": "CAT - 8KS1", "location": "Warehouse A", "remaining": "600 L"},
      {"name": "FG P200-3", "location": "Site B", "remaining": "420 L"},
      {"name": "FG P200-3", "location": "Site B", "remaining": "420 L"},
      {"name": "FG P200-3", "location": "Site B", "remaining": "420 L"},
      {"name": "FG P200-3", "location": "Site B", "remaining": "420 L"},
      {"name": "FG P200-3", "location": "Site B", "remaining": "420 L"},
      {"name": "FG P200-3", "location": "Site B", "remaining": "420 L"},
    ];

    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                const SizedBox(height: 25),

                const Text(
                  'Generators',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                const AppSearchInput(
                  hint: "Search generators",
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      thickness: 4,
                      radius: const Radius.circular(10),
                      child: GeneratorList(
                        items: generators,
                        controller: _scrollController,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          AppFloatingButton(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddGeneratorPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}