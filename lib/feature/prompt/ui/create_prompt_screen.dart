import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_generate_app/feature/prompt/bloc/prompt_bloc.dart';

class CreatePromptScreen extends StatefulWidget {
  const CreatePromptScreen({super.key});

  @override
  State<CreatePromptScreen> createState() => _CreatePromptScreenState();
}

class _CreatePromptScreenState extends State<CreatePromptScreen> {
  TextEditingController controller = TextEditingController();
  final PromptBloc promptBloc = PromptBloc();

  @override
  void initState() {
    promptBloc.add(PrompInitialEvent());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    promptBloc.close(); // Clean up the Bloc
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Images 🚀'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<PromptBloc, PromptState>(
          bloc: promptBloc,
          listener: (context, state) {
            if (state is PromptGeneratingImageErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error generating image')),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Display Area
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: _buildImageArea(state),
                  ),
                ),
                const SizedBox(height: 20),
                // Input and Button Area
                Text(
                  "Enter Your Prompt",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  cursorColor: Colors.deepPurple,
                  decoration: InputDecoration(
                    hintText: "e.g., 'A cat in space'",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      promptBloc.add(PromptEnterEvent(prompt: controller.text));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a prompt')),
                      );
                    }
                  },
                  icon: const Icon(Icons.generating_tokens),
                  label: const Text("Generate"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageArea(PromptState state) {
    switch (state.runtimeType) {
      case PromptGeneratingImageLoadState:
        return const Center(child: CircularProgressIndicator());
      case PromptGeneratingImageErrorState:
        return const Center(
          child: Text(
            'Something went wrong!',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        );
      case PromptGeneratingImageSuccessState:
        final successState = state as PromptGeneratingImageSuccessState;
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            successState.uint8list,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "Generate an image by entering a prompt below!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        );
    }
  }
}
