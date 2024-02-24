import 'package:flutter/material.dart';
import 'colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isUsernameEmpty = false;
  bool _isPasswordEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/diamond.png'),
                const SizedBox(height: 16.0),
                Text(
                  'SHOPEE TM',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 120.0),
            TextField(
              controller: _usernameController,
              onChanged: (value) {
                setState(() {
                  _isUsernameEmpty = value.isEmpty;
                });
              },
              decoration: InputDecoration(
                labelText: 'Username',
                errorText: _isUsernameEmpty ? 'Username cannot be empty' : null,
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              onChanged: (value) {
                setState(() {
                  _isPasswordEmpty = value.isEmpty;
                });
              },
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _isPasswordEmpty ? 'Password cannot be empty' : null,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12.0),
            OverflowBar(
              alignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: kShrineBrown900,
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text('NEXT'),
                  onPressed: () {
                    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
                      setState(() {
                        _isUsernameEmpty = _usernameController.text.isEmpty;
                        _isPasswordEmpty = _passwordController.text.isEmpty;
                      });
                    } else {
                      Navigator.pop(context);
                      // Menampilkan notifikasi setelah tombol "NEXT" diklik dan halaman login ditutup
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selamat datang di Shopee TM'),
                          backgroundColor: Colors.green, // Warna hijau
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: kShrineBrown900,
                    backgroundColor: kShrinePink400,
                    elevation: 8.0,
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
