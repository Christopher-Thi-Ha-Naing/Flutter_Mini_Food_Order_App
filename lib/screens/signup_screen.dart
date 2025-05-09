import 'package:flutter/material.dart';
import 'package:food_order_app/screens/login_screen.dart';
import 'package:food_order_app/screens/navigation_screen.dart';
import 'package:food_order_app/services/auth_method.dart';
import 'package:food_order_app/utils/constants.dart';
import 'package:food_order_app/widgets/text_fields.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  final TextEditingController _usernamecontroller = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();

    _usernamecontroller.dispose();
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void navigateToLogin() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void signupUser() async {
    String email = _emailcontroller.text.trim();
    String password = _passwordcontroller.text.trim();
    String name = _usernamecontroller.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      showSnackBar(context, 'Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethod().signupUser(
      email: email,
      password: password,
      name: name,
      context: context,
    );

    setState(() {
      _isLoading = false;
    });

    if (res == 'success') {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => NavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Image.asset(appLogo, width: 150),
                const SizedBox(height: 24),
                SizedBox(height: 24),
                TextFieldInput(
                  textEditingController: _usernamecontroller,
                  hint: "Please Enter the username",
                  keyboardtype: TextInputType.text,
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  textEditingController: _emailcontroller,
                  hint: "Please Enter the Email",
                  keyboardtype: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                TextFieldInput(
                  textEditingController: _passwordcontroller,
                  hint: "Please Enter the Password",
                  keyboardtype: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: signupUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: primaryColor,
                    ),
                    child:
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : const Text("SignUp"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      child: const Text("Already have an account?"),
                    ),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
