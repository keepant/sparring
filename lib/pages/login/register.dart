import 'package:cloud_functions/cloud_functions.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparring/components/bezier.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/login/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailControl = new TextEditingController();
  final TextEditingController _passwdControl = new TextEditingController();
  final TextEditingController _fullNameControl = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isHidePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text(I18n.of(context).backText,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(
    String title,
    TextEditingController controller, {
    bool isPassword = false,
    String hint = "",
    TextInputType keyboardType,
    String warningText,
    Widget suffixIcon,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: keyboardType,
            controller: controller,
            obscureText: isPassword,
            validator: (value) => value.isEmpty ? warningText : null,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              hintText: hint,
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).unfocus();
        if (_formKey.currentState.validate()) {
          Flushbar(
            message: "Loading...",
            showProgressIndicator: true,
            margin: EdgeInsets.all(8),
            borderRadius: 8,
          )..show(context);

          print(
              _fullNameControl.text + _emailControl.text + _passwdControl.text);

          final HttpsCallable callable =
              CloudFunctions.instance.getHttpsCallable(
            functionName: 'registerUser',
          );

          try {
            await callable.call(<String, dynamic>{
              'email': _emailControl.text,
              'displayName': _fullNameControl.text,
              'password': _passwdControl.text,
              'photoURL': "https://i.ibb.co/2dbTY5C/person.png",
            });

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );

            Flushbar(
              title: I18n.of(context).registerSuccessText,
              message: I18n.of(context).descRegisterSuccessText,
              margin: EdgeInsets.all(8),
              duration: Duration(seconds: 3),
              borderRadius: 8,
            )..show(context);
          } catch (e) {
            print(e);
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            )
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)],
          ),
        ),
        child: Text(
          I18n.of(context).registerText,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            I18n.of(context).questionHaveAccountText,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              I18n.of(context).loginText,
              style: TextStyle(
                color: Color(0xfff79c4f),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: I18n.of(context).title,
        style: GoogleFonts.portLligatSans(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Color(0xffe46b10),
        ),
      ),
    );
  }

  Widget _formWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _entryField(
            I18n.of(context).fullNameText,
            _fullNameControl,
            hint: "John Mayer",
            keyboardType: TextInputType.text,
            warningText: I18n.of(context).fullNameEmptyWarningText,
          ),
          _entryField(
            I18n.of(context).emailText,
            _emailControl,
            hint: "John@mayer.me",
            keyboardType: TextInputType.emailAddress,
            warningText: I18n.of(context).emailEmptyWarningText,
          ),
          _entryField(
            I18n.of(context).passwordText,
            _passwdControl,
            isPassword: _isHidePassword,
            warningText: I18n.of(context).passwordEmptyWarningText,
            suffixIcon: GestureDetector(
              onTap: () {
                _togglePasswordVisibility();
              },
              child: Icon(
                _isHidePassword ? Icons.visibility_off : Icons.visibility,
                color: _isHidePassword ? Colors.grey : Colors.blue,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _submitButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _formWidget(),
                    SizedBox(height: height * .10),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 20, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
