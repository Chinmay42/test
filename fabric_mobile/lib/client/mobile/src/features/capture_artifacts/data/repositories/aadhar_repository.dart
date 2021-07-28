
//import 'package:flutter_net_demo/networking/ApiProvider.dart';

import 'package:fabric_mobile/client/mobile/src/features/networking/ApiProvider.dart';

class AadharRepository{
  ApiProvider _provider = ApiProvider();

   add(String json) async {
    final response = await _provider.post("/add",json);
    return response;
  }

   get(String id) async {
    final response = await _provider.get("?id="+id);
    return response;
  }



}