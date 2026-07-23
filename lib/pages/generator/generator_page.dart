import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/search_input.dart';
import '../../colors.dart';
import 'generator_list.dart';
import 'add_generator.dart';
import 'update_generator_page.dart';

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
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: SafeArea(
        child: Padding(
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('generators')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Failed to load generators',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    if (docs.isEmpty) {
                      return Center(
                        child: Text(
                          'No generators yet',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      );
                    }

                    final generators = docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final remaining = data['remaining'] as num?;
                      return {
                        'id': doc.id,
                        'name': data['name'] ?? '',
                        'location': data['location'] ?? '',
                        'remaining':
                            '${remaining?.toStringAsFixed(0) ?? '0'} L',
                        'fuelCapacity': data['fuelCapacity'],
                        'fuelUsage': data['fuelUsage'],
                      };
                    }).toList();

                    return Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      thickness: 4,
                      radius: const Radius.circular(10),
                      child: GeneratorList(
                        items: generators,
                        controller: _scrollController,

                        // navigation handled here
                        onItemTap: (gen) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  GeneratorUpdatePage(generator: gen),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final saved = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => const AddGeneratorPage(),
            ),
          );
          if (saved == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Generator saved successfully")),
            );
          }
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}