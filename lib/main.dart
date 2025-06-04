import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/network/api_client.dart';
import 'features/users/data/repositories/user_repository.dart';
import 'features/users/presentation/bloc/user_bloc.dart';
import 'features/users/presentation/pages/user_list_screen.dart';
import 'features/users/presentation/pages/user_details_screen.dart';
import 'features/users/presentation/pages/create_post_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => UserBloc(
            UserRepository(ApiClient()),
          ),
          child: MaterialApp(
            title: 'User Management',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const UserListScreen(),
              '/user-details': (context) => const UserDetailsScreen(),
              '/create-post': (context) {
                final userId = ModalRoute.of(context)!.settings.arguments as int;
                return CreatePostScreen(userId: userId);
              },
            },
          ),
        );
      },
    );
  }
} 