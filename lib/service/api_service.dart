import 'dart:convert';

import 'package:http/http.dart';

class DataApiService {
  DataApiService() {}

  Future<List<String>> getData() async {
    const listData = [
      'data1',
      'data2',
      'data3',
      'data4',
      'data5',
    ];
    return listData;
    // final response = await get(Uri.parse('https://api.example.com/data'));
    // if (response.statusCode == 200) {
    //   final List<String> data = json.decode(response.body);
    //   return data;
    // } else {
    //   throw Exception('Failed to load data');
    // }
  }
}
