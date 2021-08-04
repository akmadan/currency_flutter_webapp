import 'dart:convert';

import 'package:exhange_rates_flutter/models/jsonmodel.dart';
import 'package:exhange_rates_flutter/utils/key.dart';
import 'package:http/http.dart' as http;

Future<RatesModel> fetchrates() async {
  var response = await http.get(Uri.parse(
      'https://openexchangerates.org/api/latest.json?base=USD&app_id=' + key));
  final result = ratesModelFromJson(response.body);
  return result;
}
