import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:image_generate_app/feature/prompt/ui/create_prompt_screen.dart';

import 'feature/prompt/bloc/prompt_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PromptBloc(),
      child: MaterialApp( 
          theme: ThemeData(
              appBarTheme: AppBarTheme(
                  backgroundColor: Colors.grey.shade900, elevation: 0),
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.grey.shade900),
          home: CreatePromptScreen()),
    );
  }
}
