import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'simple_auth_screen.dart';
import 'home_screen.dart';
import 'services/auth_service.dart';
import 'models/user_model.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _hasSignedOut = false;

  @override
  void initState() {
    super.initState();
    _signOutOnStart();
  }

  Future<void> _signOutOnStart() async {
    await _authService.signOut();
    setState(() {
      _hasSignedOut = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasSignedOut) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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