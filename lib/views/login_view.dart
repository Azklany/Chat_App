import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Image.asset("name"),
          const Text("Chat App"),
          const Text("Login"),
          const TextField(
            decoration: InputDecoration(labelText: "Email"),
          ),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(labelText: "Password"),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Login"),
          ),
          Row(
            children: [
              const Text("Don't have an accounr ? "),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "registerView");
                  },
                  child: const Text("Register"))
            ],
          )
        ],
      ),
    );
  }
}
