//import 'package:flutter/material.dart';
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        // This is the theme of your application.
//        //
//        // Try running your application with "flutter run". You'll see the
//        // application has a blue toolbar. Then, without quitting the app, try
//        // changing the primarySwatch below to Colors.green and then invoke
//        // "hot reload" (press "r" in the console where you ran "flutter run",
//        // or simply save your changes to "hot reload" in a Flutter IDE).
//        // Notice that the counter didn't reset back to zero; the application
//        // is not restarted.
//        primarySwatch: Colors.blue,
//      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
//    );
//  }
//}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  // This widget is the home page of your application. It is stateful, meaning
//  // that it has a State object (defined below) that contains fields that affect
//  // how it looks.
//
//  // This class is the configuration for the state. It holds the values (in this
//  // case the title) provided by the parent (in this case the App widget) and
//  // used by the build method of the State. Fields in a Widget subclass are
//  // always marked "final".
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
//
//  void _incrementCounter() {
//    setState(() {
//      // This call to setState tells the Flutter framework that something has
//      // changed in this State, which causes it to rerun the build method below
//      // so that the display can reflect the updated values. If we changed
//      // _counter without calling setState(), then the build method would not be
//      // called again, and so nothing would appear to happen.
//      _counter++;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // This method is rerun every time setState is called, for instance as done
//    // by the _incrementCounter method above.
//    //
//    // The Flutter framework has been optimized to make rerunning build methods
//    // fast, so that you can just rebuild anything that needs updating rather
//    // than having to individually change instances of widgets.
//    return Scaffold(
//      appBar: AppBar(
//        // Here we take the value from the MyHomePage object that was created by
//        // the App.build method, and use it to set our appbar title.
//        title: Text(widget.title),
//      ),
//      body: Center(
//        // Center is a layout widget. It takes a single child and positions it
//        // in the middle of the parent.
//        child: Column(
//          // Column is also a layout widget. It takes a list of children and
//          // arranges them vertically. By default, it sizes itself to fit its
//          // children horizontally, and tries to be as tall as its parent.
//          //
//          // Invoke "debug painting" (press "p" in the console, choose the
//          // "Toggle Debug Paint" action from the Flutter Inspector in Android
//          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//          // to see the wireframe for each widget.
//          //
//          // Column has various properties to control how it sizes itself and
//          // how it positions its children. Here we use mainAxisAlignment to
//          // center the children vertically; the main axis here is the vertical
//          // axis because Columns are vertical (the cross axis would be
//          // horizontal).
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//}

import 'dart:convert';

import 'package:bigshop/common/functions/getToken.dart';
import 'package:bigshop/common/functions/saveCurrentAPPLogin.dart';
import 'package:bigshop/common/functions/saveCurrentFBLogin.dart';
import 'package:bigshop/models/json/fbloginModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:bigshop/common/functions/getID.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Facebook Login"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () => facebookLogin.isLoggedIn
                  .then((isLoggedIn) => isLoggedIn ? _logout() : {}),
            ),
          ],
        ),
        body: Container(
          child: Center(
            child: isLoggedIn
                ? _displayUserData(profileData,userData)
                : _displayLoginButton(),
          ),
        ),
      ),
      theme: ThemeData(
        fontFamily: 'Raleway',
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.grey[600],
        ),
        // This colors the [InputOutlineBorder] when it is selected
        primaryColor: Colors.blue[500],
        textSelectionHandleColor: Colors.blue[500],
      ),
    );
  }

  void initiateFacebookLogin() async {
    var facebookLoginResult =
    await facebookLogin.logInWithReadPermissions(['email']);

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
        print(facebookLoginResult.accessToken.token);

        var profile = json.decode(graphResponse.body);
        var user = new FbLoginModel.fromJson(profile);
        saveCurrentFBLogin(profile);
        print(profile.toString());

//        Map<String, String> params = {
//          'grant_type': 'convert_token',
//          'client_id': 'Y46VUjckBE1I41WV1dY8PVHZHqVty0GwagTOuujK',
//          'client_secret': 'TI0i3lYvP9zmqufsd5BhzjzQoZTuWoRncJSbHvWYiImg7A3o8j51jksFtIlcUbVGv2KoTXHPe4FnZx8D6manJiRGWtsNngCWAiYDjd15h42Cv82Mt0ksAqmc3gelfN0D',
//          'backend':'facebook',
//          'token': facebookLoginResult.accessToken.token,
//          'user_type': 'customer'
//        };

        Map<String, String> params = {
          'grant_type': 'convert_token',
          'client_id': 'tTnUFMqsa8e6HBfz2K4cI8nDHl8xANhl0t89ZgHG',
          'client_secret': 'GsvfO5RrepUauvV0mbsI0dEtyAHwPiaJ0kRFpaxqxZUpxRHRr6HI8Fy4yHcEwUJaZB8WveS2x0vR31lGnP24GpAqSG0A9GBMVKKbLugvlY3exWaND7imKtMUAVsRhEEz',
          'backend':'facebook',
          'token': facebookLoginResult.accessToken.token,
          'user_type': 'customer'
        };

        var yohbiteResponse = await http.post('https://yohbite.silvatech.org/api/social/convert-token/?grant_type=${params['grant_type']}&client_id=${params['client_id']}&client_secret=${params['client_secret']}&backend=${params['backend']}&token=${params['token']}&user_type=${params['user_type']}');
        var ybprofile = json.decode(yohbiteResponse.body);
        saveCurrentAPPLogin(ybprofile);
        print(ybprofile.toString());

        var id;
        var result = await getID().then((result) {
          id = result;
        });
        print("FB ${id}");

        var token;
        var newResult = await getToken().then((newResult){
          token = newResult;
        });

        print("APP ${token}");

        onLoginStatusChanged(true, profileData: profile, userData: ybprofile);
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
