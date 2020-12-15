import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:bigshop/auth.dart';

import 'package:bigshop/common/widgets/bezierContainer.dart';
import 'package:bigshop/common/widgets/pleaseWaitWidget.dart';

import 'package:bigshop/pages/home.dart';
import 'package:bigshop/pages/signup.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _pleaseWait = false;
  bool _btnEnabled = false;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PleaseWaitWidget _pleaseWaitWidget =
  PleaseWaitWidget(key: ObjectKey("pleaseWaitWidget"));

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _showSnackBar(String content, {bool error = false}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
      Text('${error ? "An unexpected error occured: " : ""}${content}'),
    ));
  }

  _showPleaseWait(bool b) {
    setState(() {
      _pleaseWait = b;
    });
  }

  _loginUser(BuildContext context) {
    _showPleaseWait(true);
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      AuthState state = Provider.of<AuthState>(context, listen: false);
      state
          .login(_userNameController.text, _passwordController.text)
          .then((response) {
        _showPleaseWait(false);
      }).catchError((error) {
        _showPleaseWait(false);
        _showSnackBar(error.toString(), error: true);
      });
    } catch (e) {
      _showPleaseWait(false);
      _showSnackBar(e.toString(), error: true);
    }
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
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
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
              autovalidateMode: AutovalidateMode.always,
              onChanged: (val) {
                isEmpty();
              },
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _newSubmitButton() {
    return GFButton(
        onPressed: _btnEnabled == true
            ? () {
          _loginUser(context);
        }
            : null,
        onLongPress: () {},
        text: "Login",
        icon: Icon(Icons.login),
        type: GFButtonType.solid,
        blockButton: true,
        size: GFSize.LARGE);
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
          Text('or'),
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

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'B',
          style: GoogleFonts.roboto(
            textStyle: Theme
                .of(context)
                .textTheme
                .display1,
            fontSize: 60,
            fontWeight: FontWeight.w700,
            color: Theme
                .of(context)
                .accentColor,
          ),
          children: [
            TextSpan(
              text: 'ig',
              style: TextStyle(color: Colors.black, fontSize: 50),
            ),
            TextSpan(
              text: 'shop',
              style: TextStyle(
                  color: Theme
                      .of(context)
                      .primaryColor, fontSize: 50),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username", _userNameController),
        _entryField("Password", _passwordController, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;


    Widget _main() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: height * .2),
              _title(),
              SizedBox(height: 50),
              _emailPasswordWidget(),
              SizedBox(height: 20),
              // _submitButton(),
              _newSubmitButton(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.centerRight,
                child: Text('Forgot Password ?',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ),
              // _divider(),
              // _facebookButton(),
              SizedBox(height: height * .055),
              _createAccountLabel(),
            ],
          ),
        ),
      );
    }

    Widget bodyWidget = _pleaseWait ? _pleaseWaitWidget : Stack(
      key: ObjectKey("stack"), children: [_main()],);

    return Consumer<AuthState>(builder: (context, value, child) {
      return value.isLoggedIn
          ? HomePage()
          : Scaffold(
          key: _scaffoldKey,
          body: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Positioned(
                    top: -height * .15,
                    right: -MediaQuery
                        .of(context)
                        .size
                        .width * .4,
                    child: BezierContainer()),
                bodyWidget,
                Positioned(top: 40, left: 0, child: _backButton()),
              ],
            ),
          ));
    });
  }

  bool isEmpty() {
    setState(() {
      if ((_userNameController.text != " ") &&
          (_passwordController.text != " ") &&
          (_userNameController != null) &&
          (_passwordController != null) &&
          (_userNameController.text.length > 5) &&
          (_passwordController.text.length > 5)) {
        _btnEnabled = true;
      } else {
        _btnEnabled = false;
      }
    });
    return _btnEnabled;
  }
}
