import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'services/auth_service.dart';
import 'models/user_model.dart';

class SimpleAuthScreen extends StatefulWidget {
  @override
  _SimpleAuthScreenState createState() => _SimpleAuthScreenState();
}

class _SimpleAuthScreenState extends State<SimpleAuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLogin = true;
  bool _isLoading = false;
  String _selectedRole = 'inspector';

  void _authenticate() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (!_isLogin && _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      UserModel? user;
      
      if (_isLogin) {
        // Sign in existing user
        user = await _authService.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        // Register new user
        user = await _authService.registerWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          role: _selectedRole,
        );
      }
      
      if (user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen(userRole: user!.role)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[900]!, Colors.blue[600]!, Colors.blue[400]!],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: 60),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.train, size: 60, color: Colors.blue[600]),
                ),
                SizedBox(height: 24),
                Text('QRail', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Railway Inspection System', style: TextStyle(fontSize: 16, color: Colors.white70)),
                SizedBox(height: 40),
                
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Login/Register Toggle
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isLogin = true),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _isLogin ? Colors.blue[600] : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Login',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: _isLogin ? Colors.white : Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isLogin = false),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: !_isLogin ? Colors.blue[600] : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Register',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: !_isLogin ? Colors.white : Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        
                        // Role Selection for Registration
                        if (!_isLogin) ...[
                          Text('Select Role', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedRole = 'inspector'),
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _selectedRole == 'inspector' ? Colors.blue[100] : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _selectedRole == 'inspector' ? Colors.blue : Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(Icons.search, color: _selectedRole == 'inspector' ? Colors.blue : Colors.grey),
                                        SizedBox(height: 4),
                                        Text('Inspector', style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedRole = 'vendor'),
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _selectedRole == 'vendor' ? Colors.teal[100] : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _selectedRole == 'vendor' ? Colors.teal : Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(Icons.qr_code, color: _selectedRole == 'vendor' ? Colors.teal : Colors.grey),
                                        SizedBox(height: 4),
                                        Text('Vendor', style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                        
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 24),
                        
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _authenticate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(_isLogin ? 'Login' : 'Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        
                        if (_isLogin) ...[
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text('Demo Accounts:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                                SizedBox(height: 8),
                                Text('inspector@demo.com - Inspector', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text('vendor@demo.com - Vendor', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                Text('Any password works', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}