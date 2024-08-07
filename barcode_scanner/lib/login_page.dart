import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _validUsername = 'admin'; // Replace with your valid username
  final String _validPassword = 'password'; // Replace with your valid password
  String _errorMessage = '';
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    if (_isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/spreadsheet_select', (route) => false);
    }
  }

  Future<void> _login() async {
    String enteredUsername = _usernameController.text.trim();
    String enteredPassword = _passwordController.text.trim();

    if (enteredUsername == _validUsername &&
        enteredPassword == _validPassword) {
      setState(() {
        _errorMessage = '';
        _isLoggedIn = true;
      });
      // Navigate to the next screen or perform any action upon successful login
      Navigator.pushNamedAndRemoveUntil(
          context, '/spreadsheet_select', (route) => false);
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            if (_errorMessage.isNotEmpty) ...[
              SizedBox(height: 10.0),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
