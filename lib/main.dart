import 'package:flutter/material.dart';

// 1. Importe o seu arquivo de tema
// !! CONFIRME SE 'super_trunfo' é o nome no seu pubspec.yaml !!
import 'package:super_trunfo/core/theme/theme.dart';

Future<void> main() async {
  // Garante que o Flutter está pronto
  WidgetsFlutterBinding.ensureInitialized();

  // (Aqui virá a inicialização do Hive que planejamos)
  // await Hive.initFlutter();
  // ... registro dos adapters ...

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // 2. Crie a instância do MaterialTheme.
    //    Ele precisa de um TextTheme base para funcionar.
    //    Vamos usar o TextTheme padrão do Flutter (claro).
    final materialTheme = MaterialTheme(ThemeData.light().textTheme);

    return MaterialApp(
      title: 'Super Trunfo Heróis',
      debugShowCheckedModeBanner: false,

      themeMode: ThemeMode.system, // Usa o tema (claro/escuro) do celular

      // 3. Chame os *métODOS* .light() e .dark() da sua instância
      theme: materialTheme.light(),

      darkTheme: materialTheme.dark(),

      // Placeholder da tela inicial
      home: const Scaffold(
        body: Center(
          child: Text('Tela Inicial em Breve'),
        ),
      ),
    );
  }
}