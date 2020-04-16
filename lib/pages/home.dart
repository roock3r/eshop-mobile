import 'dart:async';
import 'dart:io';
import 'package:bigshop/common/apifunctions/requestLogoutAPI.dart';
import 'package:bigshop/pages/about.dart';
import 'package:bigshop/pages/cart.dart';
import 'package:bigshop/pages/dashboard.dart';
import 'package:bigshop/pages/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bigshop/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Dashboard", Icons.home),
    new DrawerItem("Cart", Icons.shopping_basket),
    new DrawerItem("Orders", Icons.list),
    new DrawerItem("About", Icons.event_note),
    new DrawerItem("Sign Out", Icons.exit_to_app)

  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;
  String _name  = "";
  String _email = "";
  String _picture = "";

  @override
  void initState() {
    super.initState();
    _saveCurrentRoute("/home");
    _loadUser();
  }

  _loadUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _name = preferences.getString("LastUser");
      _email = preferences.getString("LastEmail");
      _picture = preferences.getString("LastPicture");
    });
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastScreenRoute', lastRoute);
  }

  Widget _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new DashboardPage();
      case 1:
        return new CartPage();
      case 2:
        return new OrdersPage();
      case 3:
        return new AboutPage();
      case 4:
        return new LoginPage();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    if (index == 4){
      requestLogoutAPI(context);
      Navigator.of(context).pushReplacementNamed('/loginScreen');
    }else{
      setState(() => _selectedDrawerIndex = index);
      Navigator.of(context).pop();
    }
    // close the drawer
  }
  //modification ends here


  Future<bool> _exitApp(BuildContext context) {
    return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text('Do you want to exit this application?'),
        content: new Text('We hate to see you leave...'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
        new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        ),

      );
    }

    Future<bool> showLoginPage() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString("LastAccessToken");
      return token == null;
    }

    return WillPopScope(
        onWillPop: () => _exitApp(context),
        child: FutureBuilder<bool>(
          future: showLoginPage(),
          builder: (buildContext, snapshot) {
            if(snapshot.hasData) {
              if(snapshot.data){
                // Return your login here
                return LoginPage();
              }

              // Return your home here
              return Scaffold(
                appBar: AppBar(
                  // Here we take the value from the MyHomePage object that was created by
                  // the App.build method, and use it to set our appbar title.
                  title: Text("Bigshop"),
                ),
                drawer: new Drawer(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          accountName: Text('${_name.toUpperCase()}'),
                          accountEmail: Text('${_email}'),
                          currentAccountPicture: CircleAvatar(
                            backgroundImage: Image.network('${_picture}').image,
                            backgroundColor:
                            Theme.of(context).platform == TargetPlatform.iOS
                                ? Colors.blue
                                : Colors.white,
                            child: Text(
                              '${_name.substring(0, 1)}',
                              style: TextStyle(fontSize: 40.0,),

                            ),
                          ),
                        ),
                        new Column(children: drawerOptions),
                      ],
                    )
                ),
                body: _getDrawerItemWidget(_selectedDrawerIndex),
              );
            } else {
              // Return loading screen while reading preferences
              return Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }


}



//import 'dart:async';
//import 'dart:io';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:streambelize/channels/AboutView.dart';
//import 'package:streambelize/channels/Channel5View.dart';
//import 'package:streambelize/channels/Channel7View.dart';
//import 'package:streambelize/channels/Ctv3View.dart';
//import 'package:streambelize/channels/FiestaTvView.dart';
//import 'package:streambelize/channels/KremTvView.dart';
//import 'package:streambelize/channels/LoveTvView.dart';
//import 'package:streambelize/channels/MaxTvView.dart';
//import 'package:streambelize/channels/PlusTvView.dart';
//import 'package:streambelize/channels/VibesTvView.dart';
//import 'package:streambelize/channels/WaveTvView.dart';
//import 'package:streambelize/channels/HomeView.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:streambelize/common/functions/getToken.dart';
//import 'package:streambelize/common/apifunctions/requestLogoutAPI.dart';
//import 'package:streambelize/ui/SigninScreen.dart';
//
//
//
//class DrawerItem {
//  String title;
//  IconData icon;
//  DrawerItem(this.title, this.icon);
//}
//
//class ScaffoldScreen extends StatefulWidget {
////  ScaffoldScreen({Key key, this.title}) : super(key: key);
//
//  final drawerItems = [
//    new DrawerItem("Home Page", Icons.home),
//    new DrawerItem("Channel 5", Icons.arrow_forward),
//    new DrawerItem("Channel 7", Icons.arrow_forward),
//    new DrawerItem("Love TV", Icons.arrow_forward),
//    new DrawerItem("Krem TV", Icons.arrow_forward),
//    new DrawerItem("Plus TV", Icons.arrow_forward),
//    new DrawerItem("CTV3 TV", Icons.arrow_forward),
//    new DrawerItem("Vibes TV", Icons.arrow_forward),
//    new DrawerItem("Wave TV", Icons.arrow_forward),
//    new DrawerItem("MAX TV", Icons.arrow_forward),
//    new DrawerItem("Fiesta TV", Icons.arrow_forward),
//    new DrawerItem("About", Icons.arrow_forward),
//    new DrawerItem("Sign Out", Icons.arrow_forward)
//
//  ];
//
////  final String title;
//
//  @override
//  _ScaffoldScreenState createState() => _ScaffoldScreenState();
//}
//
//class _ScaffoldScreenState extends State<ScaffoldScreen> {
//
//  bool isSignedIn = false;
//  bool isAuthorized = false;
//  int _selectedDrawerIndex = 0;
//  String _name  = "";
//  String _email = "";
//  String _token = "";
//  String _avatar = "";
//
//
//  //FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//
//  @override
//  void initState() {
//    super.initState();
//    _saveCurrentRoute("/ScaffoldScreen");
//    //firebaseCloudMessaging_Listeners();
//    _loadUser();
//
//  }
//
//  Widget _getDrawerItemWidget(int pos) {
//    switch (pos) {
//      case 0:
//        return new HomePage();
//      case 1:
//        return new Channel5(title: 'Channel 5',url: 'https://connect.streambelize.live/LiveApp/streams/933564207825213990830532.m3u8', color: Colors.lightBlue);
//      case 2:
//        return new Channel7(title: 'Channel 7',url: 'https://www.youtube.com/watch?v=Rtbzr79anLY',color: Colors.lightBlue);
//      case 3:
//        return new LoveTv(title: 'Love TV',url: 'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8', color: Colors.red,);
//      case 4:
//        return new KremTv(title: 'KREM TV',url: 'https://streambelize.com/kremtv/b3c92z.m3u8',color: Colors.lightBlue,);
//      case 5:
//        return new PlusTv(title: 'Plus TV',url: 'https://streambelize.com/plustv/8v9r4k.m3u8',color: Colors.lightBlue,);
//      case 6:
//        return new Ctv3(title: 'CTV 3',url: 'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8',color: Colors.lightBlue,);
//      case 7:
//        return new VibesTv(title: 'Vibes TV',url: 'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8',color: Colors.lightBlue);
//      case 8:
//        return new WaveTv(title: 'Wave TV',url: 'https://streambelize.com/wavetv/3q8p9c.m3u8',color: Colors.redAccent);
//      case 9:
//        return new MaxTv(title: 'Max TV',url: 'https://streambelize.com/maxtv/test.m3u8',color: Colors.lightBlue,);
//      case 10:
//        return new FiestaTv(title: 'Fiesta TV',url: 'https://streambelize.com/fiesta/a1s2d3.m3u8',color: Colors.lightBlue,);
//      case 11:
//        return new AboutView();
//      case 12:
//        return SigninScreen();
//
//      default:
//        return new Text("Error");
//    }
//  }
//
//  _onSelectItem(int index) {
//    if (index == 12){
//      requestLogoutAPI(context);
//      Navigator.of(context).pushReplacementNamed('/SigninScreen');
//    }else{
//      setState(() => _selectedDrawerIndex = index);
//      Navigator.of(context).pop();
//    }
//    // close the drawer
//  }
//  //modification ends here
//  _saveCurrentRoute(String lastRoute) async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    await preferences.setString('LastScreenRoute', lastRoute);
//  }
//
//
//
//  Future<bool> _exitApp(BuildContext context) {
//    return showDialog(
//      context: context,
//      child: new AlertDialog(
//        title: new Text('Do you want to exit this application?'),
//        content: new Text('We hate to see you leave...'),
//        actions: <Widget>[
//          new FlatButton(
//            onPressed: () => Navigator.of(context).pop(false),
//            child: new Text('No'),
//          ),
//          new FlatButton(
//            onPressed: () => Navigator.of(context).pop(true),
//            child: new Text('Yes'),
//          ),
//        ],
//      ),
//    ) ??
//        false;
//  }
//
//  _loadUser() async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    setState(() {
//      _token = preferences.getString("LastToken");
//      _name = preferences.getString("LastUser");
//      _email = preferences.getString("LastEmail");
//      _avatar = preferences.getString("LastUserAvatar");
//    });
//  }
//
//  //Modifcation starts here
//
////  void firebaseCloudMessaging_Listeners() {
////    if (Platform.isIOS) iOS_Permission();
////
////    _firebaseMessaging.getToken().then((token){
////      print(token);
////    });
////
////    _firebaseMessaging.configure(
////      onMessage: (Map<String, dynamic> message) async {
////        print('on message $message');
////        showDialog(
////          context: context,
////          builder: (context) => AlertDialog(
////            content: ListTile(
////              title: Text(message['notification']['title']),
////              subtitle: Text(message['notification']['body']),
////            ),
////            actions: <Widget>[
////              FlatButton(
////                child: Text('Ok'),
////                onPressed: () => Navigator.of(context).pop(),
////              ),
////            ],
////          ),
////        );
////      },
////      onResume: (Map<String, dynamic> message) async {
////        print('on resume $message');
////      },
////      onLaunch: (Map<String, dynamic> message) async {
////        print('on launch $message');
////      },
////    );
////  }
//
////  void iOS_Permission() {
////    _firebaseMessaging.requestNotificationPermissions(
////        IosNotificationSettings(sound: true, badge: true, alert: true)
////    );
////    _firebaseMessaging.onIosSettingsRegistered
////        .listen((IosNotificationSettings settings)
////    {
////      print("Settings registered: $settings");
////    });
////  }
//
//
//  Widget _getDrawerItemWidget(int pos) {
//    switch (pos) {
//      case 0:
//        return new HomePage();
//      case 1:
//        return new Channel5(title: 'Channel 5',url: 'https://connect.streambelize.live/LiveApp/streams/933564207825213990830532.m3u8', color: Colors.lightBlue);
//      case 2:
//        return new Channel7(title: 'Channel 7',url: 'https://www.youtube.com/watch?v=Rtbzr79anLY',color: Colors.lightBlue);
//      case 3:
//        return new LoveTv(title: 'Love TV',url: 'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8', color: Colors.red,);
//      case 4:
//        return new KremTv(title: 'KREM TV',url: 'https://streambelize.com/kremtv/b3c92z.m3u8',color: Colors.lightBlue,);
//      case 5:
//        return new PlusTv(title: 'Plus TV',url: 'https://streambelize.com/plustv/8v9r4k.m3u8',color: Colors.lightBlue,);
//      case 6:
//        return new Ctv3(title: 'CTV 3',url: 'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8',color: Colors.lightBlue,);
//      case 7:
//        return new VibesTv(title: 'Vibes TV',url: 'https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8',color: Colors.lightBlue);
//      case 8:
//        return new WaveTv(title: 'Wave TV',url: 'https://streambelize.com/wavetv/3q8p9c.m3u8',color: Colors.redAccent);
//      case 9:
//        return new MaxTv(title: 'Max TV',url: 'https://streambelize.com/maxtv/test.m3u8',color: Colors.lightBlue,);
//      case 10:
//        return new FiestaTv(title: 'Fiesta TV',url: 'https://streambelize.com/fiesta/a1s2d3.m3u8',color: Colors.lightBlue,);
//      case 11:
//        return new AboutView();
//      case 12:
//        return SigninScreen();
//
//      default:
//        return new Text("Error");
//    }
//  }
//
//  _onSelectItem(int index) {
//    if (index == 12){
//      requestLogoutAPI(context);
//      Navigator.of(context).pushReplacementNamed('/SigninScreen');
//    }else{
//      setState(() => _selectedDrawerIndex = index);
//      Navigator.of(context).pop();
//    }
//    // close the drawer
//  }
//  //modification ends here
//  _saveCurrentRoute(String lastRoute) async {
//    SharedPreferences preferences = await SharedPreferences.getInstance();
//    await preferences.setString('LastScreenRoute', lastRoute);
//  }
//
//
//
//  Future<bool> _exitApp(BuildContext context) {
//    return showDialog(
//      context: context,
//      child: new AlertDialog(
//        title: new Text('Do you want to exit this application?'),
//        content: new Text('We hate to see you leave...'),
//        actions: <Widget>[
//          new FlatButton(
//            onPressed: () => Navigator.of(context).pop(false),
//            child: new Text('No'),
//          ),
//          new FlatButton(
//            onPressed: () => Navigator.of(context).pop(true),
//            child: new Text('Yes'),
//          ),
//        ],
//      ),
//    ) ??
//        false;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    print('$_name $_email $_token $_avatar');
//    List<Widget> drawerOptions = [];
//    for (var i = 0; i < widget.drawerItems.length; i++) {
//      var d = widget.drawerItems[i];
//      drawerOptions.add(
//        new ListTile(
//          leading: new Icon(d.icon),
//          title: new Text(d.title),
//          selected: i == _selectedDrawerIndex,
//          onTap: () => _onSelectItem(i),
//        ),
//
//      );
//    }
//
//    return WillPopScope(
//        onWillPop: () => _exitApp(context),
//        child: FutureBuilder<bool>(
//          future: showLoginPage(),
//          builder: (buildContext, snapshot) {
//            if(snapshot.hasData) {
//              if(snapshot.data){
//                // Return your login here
//                return SigninScreen();
//              }
//
//              // Return your home here
//              return Scaffold(
//                appBar: AppBar(
//                  // Here we take the value from the MyHomePage object that was created by
//                  // the App.build method, and use it to set our appbar title.
//                  title: Text("Stream Belize Live"),
//                ),
//                drawer: new Drawer(
//                    child: ListView(
//                      padding: EdgeInsets.zero,
//                      children: <Widget>[
//                        UserAccountsDrawerHeader(
//                          accountName: Text("$_name".toUpperCase()),
//                          accountEmail: Text("$_email"),
//                          currentAccountPicture: CircleAvatar(
//                            backgroundImage: Image.network('http:$_avatar').image,
//                            backgroundColor:
//                            Theme.of(context).platform == TargetPlatform.iOS
//                                ? Colors.blue
//                                : Colors.white,
//                            child: Text(
//                              "$_name".substring(0, 1),
//                              style: TextStyle(fontSize: 40.0,),
//
//                            ),
//                          ),
//                        ),
//                        new Column(children: drawerOptions),
//                      ],
//                    )
//                ),
//                body: _getDrawerItemWidget(_selectedDrawerIndex),
//              );
//            } else {
//              // Return loading screen while reading preferences
//              return Center(child: CircularProgressIndicator());
//            }
//          },
//        )
//    );
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//  }
//}
