import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

import 'package:bigshop/common/functions/getToken.dart';
import 'package:bigshop/common/functions/saveLogout.dart';
import 'package:bigshop/models/json/appLoginModel.dart';
import 'package:bigshop/pages/login.dart' as login;

Future<AppLoginModel> requestLogoutAPI(BuildContext context) async {

  var token;


  await getToken().then((result) {
    token = result;
  });

  Map<String, String> params = {
    'client_id': 'P7kj0ctO6a02P5y2feYKLeZlhRKqyITGRRLU8v7h',
    'client_secret': 'mthsZSE6keHDeE0IgGq3Smlg7gpAx25aGIx0mvtzdCNSkpjCPPz5rjrrHKxPSn0Su9xFH8qbJsJScgIeemezPfLrdCFs7sFEqdHBT8Kiy0vUCSMwSim491iBq2iTdblR',
    'token': token,
  };

  final url = "https://bigshop.silvatech.org/api/social/revoke-token/?client_id=${params['client_id']}&client_secret=${params['client_secret']}&token=${params['token']}";

  final response = await http.post(
    url,
  );

  if (response.statusCode == 200) {
    saveLogout();
    return null;
  } else {
    saveLogout();
    return null;
  }
}