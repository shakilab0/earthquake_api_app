
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as Http;
import '../model/earth_quake_response.dart';



class EarthQuakeProvider extends ChangeNotifier{

  EarthQuakeResponse? earthQuakeResponse;

  bool get hasDataLoaded=>earthQuakeResponse!=null;

  Future<void>getEarthQuakeDetails({
    String startDate = '2022-11-20',
    String endDate = '2022-11-20',
    double magnitude = 5.0,
  }) async{
    final urlString ="https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=$startDate&endtime=$endDate&minmagnitude=$magnitude";
    try{
      final response=await Http.get(Uri.parse(urlString));
      final map = json.decode(response.body);
      if(response.statusCode==200){
        earthQuakeResponse=EarthQuakeResponse.fromJson(map);
        notifyListeners();
      }else{
        print(response.statusCode.toString());
      }
    }catch(error){
      print(error.toString());

    }
  }


}