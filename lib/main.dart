import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_scaffold.dart';
import 'services/data_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataService(), // Create the central data service
      child: MaterialApp(
        title: 'Aura Flow',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(77, 182, 172, 1),
          ),
          useMaterial3: true,
        ),
        home: const MainScaffold(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}