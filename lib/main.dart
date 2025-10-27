import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:super_trunfo/data/models/hero.dart';
import 'package:super_trunfo/core/theme/theme.dart';
import 'package:super_trunfo/presentation/screens/home_screen.dart';

Future<void> main() async {
  // Garante que o Flutter está pronto
  WidgetsFlutterBinding.ensureInitialized();

  // --- NOSSO NOVO CÓDIGO ---
  // 4. Inicializa o Hive no celular
  await Hive.initFlutter();

  // 5. Registra TODOS os Adapters que o build_runner gerou.
  //    Isso ensina o Hive a ler/escrever cada classe.
  Hive.registerAdapter(HeroAdapter());
  Hive.registerAdapter(AppearanceAdapter());
  Hive.registerAdapter(BiographyAdapter());
  Hive.registerAdapter(ConnectionsAdapter());
  Hive.registerAdapter(ImagesAdapter());
  Hive.registerAdapter(PowerstatsAdapter());
  Hive.registerAdapter(WorkAdapter());
  // (Os nomes vêm das suas classes: "NomeDaClasse" + "Adapter")
  // --- FIM DO NOVO CÓDIGO ---

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Cria a instância do MaterialTheme (como já estava)
    final materialTheme = MaterialTheme(ThemeData.light().textTheme);

    return MaterialApp(
      title: 'Super Trunfo Heróis',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,

      // Temas (como já estava)
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),

      // Placeholder da tela inicial
      home: const HomeScreen(),
    );
  }
}