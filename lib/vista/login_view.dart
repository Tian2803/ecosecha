
import 'package:ecosecha/components/custom/custom_button.dart';
import 'package:ecosecha/components/custom/custom_formfield.dart';
import 'package:ecosecha/components/custom/custom_header.dart';
import 'package:ecosecha/components/custom/custom_richtext.dart';
import 'package:ecosecha/controlador/auth_controller.dart';
import 'package:ecosecha/controlador/controller_auxiliar.dart';
import 'package:ecosecha/styles/app_colors.dart';
import 'package:ecosecha/vista/register_campesino_view.dart';
import 'package:ecosecha/vista/register_user_view.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SigninState();
}

class _SigninState extends State<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();
  bool _obscureText = true;
  String? _errorTextPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColors.blue,
          ),
          const CustomHeader(
            text: 'Log In.',
            /*onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OnboardScreen()));
            },*/
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: AppColors.whiteshade,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.09),
                      child: Image.asset("assets/images/ecosecha_logo.png"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomFormField(
                      headingText: "Email",
                      hintText: "exampledelivery@gmail.com",
                      obsecureText: false,
                      suffixIcon: const SizedBox(),
                      controller: _emailController,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      headingText: "Password",
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.text,
                      hintText: "At least 15 Character",
                      obsecureText: _obscureText,
                      suffixIcon: IconButton(
                          icon: _obscureText
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          }),
                      controller: _passwordController,
                      errorText: _errorTextPassword,
                      onChanged: (value) {
                        setState(() {
                          _errorTextPassword = (AuxController()
                                  .isPasswordLengthValid(value))
                              ? 'Password must be at least 15 characters long'
                              : null;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: AppColors.blue.withOpacity(0.7),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AuthButton(
                      onTap: () {
                        AuthController().signInUser(context, email, password);
                      },
                      text: 'Sign In',
                    ),
                    CustomRichText(
                      discription: "Don't already Have an account? ",
                      text: "Sign Up usuario",
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpUser()));
                      },
                    ),
                    CustomRichText(
                      text: "Sign Up Campesino",
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpFarmer()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
