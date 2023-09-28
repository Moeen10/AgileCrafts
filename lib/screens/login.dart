import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/bloc/LoginCubit/LoginCubit.dart';
import 'package:task/bloc/LoginCubit/LoginState.dart';
import 'package:task/screens/homePage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController username = TextEditingController(text: "asif");
  final TextEditingController password =
      TextEditingController(text: "password1");
  @override
  Widget build(BuildContext context) {
    String usernameValue;
    String passwordValue;

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
        if (state is LoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SuccessState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
        } else if (state is ErrorState) {
          return Center(child: Text("Login Failed"));
          // Show an error message to the user
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        "Get Started!!!",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                        image: AssetImage("assets/images/rename.jpg"),
                        height: 250,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      decoration: InputDecoration(labelText: 'Username'),
                      controller: username,
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      controller: password,
                    ),

                    // --------------------  Login Button   ---------------------------------

                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          final data = password.text;
                          final data2 = username.text;
                          print(data);
                          print(data2);
                          // BlocProvider.of<YourCubit>(context).updateData(data);
                          BlocProvider.of<LoginCubit>(context)
                              .loginfun(data, data2);
                        },
                        child: Text('Submit')),

                    const SizedBox(
                      height: 15,
                    ),

                    TextButton(
                        onPressed: () {},
                        child: const Text("Forgot password?")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: const Text("create account")),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
