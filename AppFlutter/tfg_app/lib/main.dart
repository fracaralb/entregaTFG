import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tfg_app/routes/routes.dart';
import 'package:tfg_app/screens/screens.dart';
import 'package:tfg_app/services/services.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MatchService(),
          lazy: false,
        )
      ],
      child:  MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TFG Predicciones',
      routes: AppRoutes.getAppRoutes(),
      initialRoute: 'main',

    );
  }
}