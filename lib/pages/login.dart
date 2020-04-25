import 'dart:convert';
import 'package:bigshop/common/functions/saveCurrentAPPLogin.dart';
import 'package:bigshop/common/functions/saveCurrentFBLogin.dart';
import 'package:bigshop/models/json/fbloginModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>() ;
  bool isLoggedIn = false;
  var profileData;
  var userData;

  var facebookLogin = FacebookLogin();


  void onLoginStatusChanged(bool isLoggedIn, {profileData,userData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
      this.userData = userData;

    });
  }

  @override
  void initState() {
    super.initState();
    _saveCurrentRoute("/loginScreen");
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastScreenRoute', lastRoute);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context) ;
    return new Scaffold(
      body: new Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Theme.of(context).accentColor,
                    Theme.of(context).secondaryHeaderColor,
                    Theme.of(context).primaryColor
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.35, 1.0])),
          child: isLoggedIn ? Center(
                child: _displayUserData(profileData, userData),
              ): new Column(
            children: <Widget>[
              new Expanded(
                  flex: 5,
                  child: Center(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                color: Colors.black12,
                                margin: new EdgeInsets.all(30.0),
                                width: 250.0,
                                height: 250.0,
                                child: new Image.asset(
                                  'images/gro.png',
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new SizedBox(width: ScreenUtil().setWidth(10.0)),
                              new Text(
                                "Bigshop",
                                style: new TextStyle(
                                    fontSize: ScreenUtil().setSp(130.0),
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ))),
              new Expanded(
                  flex: 3,
                  child: new Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(75.0)),
                    child: new Column(
                      children: <Widget>[
                        new Text(
                          'By clicking "Log in",you agree with our Terms.\n Learn how we process your data in our Privacy  Policy and Cookies Policy. A Cristian Silva Production.',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        new SizedBox(height: ScreenUtil().setHeight(50.0)),
                        new SizedBox(height: ScreenUtil().setHeight(30.0)),
                        new Container(
                          width: double.infinity,
                          height: ScreenUtil().setHeight(105.0),
                          child: new RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90.0)),
                            color: Colors.white,
                            elevation: 0.0,
                            onPressed: () => initiateFacebookLogin(),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text(
                                  "LOG IN WITH FACEBOOK",
                                  style: new TextStyle(
                                      color: Colors.grey, wordSpacing: 1.2),
                                )
                              ],
                            ),
                          ),
                        ),
                        new SizedBox(height: ScreenUtil().setHeight(60.0)),
                        new Text(
                          "Trouble logging in?",
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(40.0),
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          )),
    );
  }

  void initiateFacebookLogin() async {
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    var facebookLoginResult =
    await facebookLogin.logIn(['email']);


    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,gender,birthday,email,picture.width(400)&access_token=${facebookLoginResult
                .accessToken.token}');
        var profile = json.decode(graphResponse.body);
        saveCurrentFBLogin(profile);

        Map<String, String> params = {
          'grant_type': 'convert_token',
          'client_id': 'P7kj0ctO6a02P5y2feYKLeZlhRKqyITGRRLU8v7h',
          'client_secret': 'mthsZSE6keHDeE0IgGq3Smlg7gpAx25aGIx0mvtzdCNSkpjCPPz5rjrrHKxPSn0Su9xFH8qbJsJScgIeemezPfLrdCFs7sFEqdHBT8Kiy0vUCSMwSim491iBq2iTdblR',
          'backend':'facebook',
          'token': facebookLoginResult.accessToken.token,
          'user_type': 'customer'
        };

        var yohbiteResponse = await http.post('https://bigshop.silvatech.org/api/social/convert-token/?grant_type=${params['grant_type']}&client_id=${params['client_id']}&client_secret=${params['client_secret']}&backend=${params['backend']}&token=${params['token']}&user_type=${params['user_type']}');

        var ybprofile = json.decode(yohbiteResponse.body);
        saveCurrentAPPLogin(ybprofile);

        onLoginStatusChanged(true, profileData: profile, userData: ybprofile);
        Navigator.of(context).pushReplacementNamed('/home');
        break;
    }
  }

  _displayUserData(profileData,userData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                profileData['picture']['data']['url'],
              ),
            ),
          ),
        ),
        SizedBox(height: 28.0),
        Text(
          "FBID ${profileData['id']}\n${profileData['name']}\n${profileData['email']}",
          style: TextStyle(
            fontSize: 20.0,
            letterSpacing: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  _displayLoginButton() {
    return RaisedButton(
      child: Text("Login with Facebook"),
      onPressed: () => initiateFacebookLogin(),
      color: Colors.blue,
      textColor: Colors.white,
    );
  }

  _logout() async {
    await facebookLogin.logOut();
    onLoginStatusChanged(false);
    print("Logged out");
  }

}
