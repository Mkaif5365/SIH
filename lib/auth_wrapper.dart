import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'simple_auth_screen.dart';
import 'home_screen.dart';
import 'services/auth_service.dart';
import 'models/user_model.dart';

class AuthWrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasData) {
          // User is signed in, get user data and navigate to home
          return FutureBuilder<UserModel?>(
            future: _authService.getCurrentUserData(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              if (userSnapshot.hasData && userSnapshot.data != null) {
                return HomeScreen(userRole: userSnapshot.data!.role);
              }
              
              // If user data not found, sign out and show auth screen
              _authService.signOut();
              return SimpleAuthScreen();
            },
          );
        }
        
        // User is not signed in
        return SimpleAuthScreen();
      },
    );
  }
}