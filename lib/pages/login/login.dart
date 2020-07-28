import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sparring/components/bezier.dart';
import 'package:sparring/i18n.dart';
import 'package:sparring/pages/login/register.dart';
import 'package:sparring/services/auth.dart';
import 'package:sparring/services/prefs.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailControl = new TextEditingController();
  final TextEditingController _passwdControl = new TextEditingController();

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
            duration: Duration(seconds: 3),
          )..show(context);

          //auth
          final auth = new Auth();
          String _token;

          try {
            _token = await auth.signInWithEmail(
                _emailControl.text, _passwdControl.text);
          } catch (e) {
            Flushbar(
              message: e,
              margin: EdgeInsets.all(8),
              borderRadius: 8,
              duration: Duration(seconds: 4),
            )..show(context);
            FocusScope.of(context).requestFocus(new FocusNode());
          }

          if (_token != null) {
            print(_emailControl.text + _passwdControl.text);

            await prefs.setToken(_token);

            String userId = await auth.getUid();
            await prefs.setUserId(userId);
            print("token: " + _token + "userid: " + userId);
            OneSignal.shared.setExternalUserId(userId);

            Navigator.of(context).popUntil(ModalRoute.withName("/"));

            FocusScope.of(context).unfocus();
            Flushbar(
              message: I18n.of(context).loginSuccessText,
              margin: EdgeInsets.all(8),
              borderRadius: 8,
              duration: Duration(seconds: 3),
            )..show(context);
          } else {
            FocusScope.of(context).requestFocus(new FocusNode());
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
          I18n.of(context).loginText,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text(I18n.of(context).orText),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _googleButton() {
    return InkWell(
      onTap: () async {
        print('tap google login button');

        final auth = new Auth();
        String _token;

        _token = await auth.signInWithGoogle();
        print("token: " + _token);
        await prefs.setToken(_token);

        String userId = await auth.getUid();
        await prefs.setUserId(userId);

        OneSignal.shared.setExternalUserId(userId);

        Navigator.of(context).popUntil(ModalRoute.withName("/"));

        Flushbar(
          message: I18n.of(context).loginSuccessText,
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 3),
        )..show(context);
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Hexcolor('#4285F4')),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5),
                  ),
                ),
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage("assets/icon/google_logo.png"),
                  height: 25.0,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Hexcolor('#4285F4'),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  I18n.of(context).loginWithGoogleText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            I18n.of(context).questionAccountText,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            child: Text(
              I18n.of(context).registerText,
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
            I18n.of(context).emailText,
            _emailControl,
            hint: "john@mayer.me",
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
          SizedBox(height: 20),
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
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(height: 50),
                    _formWidget(),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      // child: Text('Forgot Password ?',
                      //     style: TextStyle(
                      //         fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                    _divider(),
                    SizedBox(height: 20),
                    //_facebookButton(),
                    _googleButton(),
                    SizedBox(height: height * .055),
                    _createAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 30, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
