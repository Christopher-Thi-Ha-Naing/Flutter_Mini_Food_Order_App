import 'package:flutter/material.dart';
import 'package:food_order_app/screens/navigation_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage.init();

  await Supabase.initialize(
    url: "https://znouscfzendmtbsnsvja.supabase.co",
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpub3VzY2Z6ZW5kbXRic25zdmphIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI2NTI0NzksImV4cCI6MjA1ODIyODQ3OX0.IdJG17lHJq7d_o7R50KX8ja8d-Kt2MGQEnifme2cxVI',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delicious',
      debugShowCheckedModeBanner: false,
      home: const NavigationScreen(),
    );
  }
}
