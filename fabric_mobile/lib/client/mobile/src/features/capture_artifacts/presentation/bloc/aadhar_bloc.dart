import 'dart:convert';

import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/data/models/aadhar_model.dart';
import 'package:fabric_mobile/client/mobile/src/features/capture_artifacts/data/repositories/aadhar_repository.dart';



class AadharBloc {

  AadharRepository  _aadharRepository;



  AadharBloc(){


    _aadharRepository=AadharRepository();


  }


  Future<AadharModel> add_aadhar(String aadhar_no,String user_id) async {
    Map<String, dynamic> respdata;
    try {

//var respdata;
      Map data = {
        'adno': aadhar_no,
        'userid': user_id
      };



       respdata= await _aadharRepository.add(jsonEncode(data));

      return AadharModel(false,respdata['ad-id']);
      // Response.completed(chuckCats);
    } catch (e) {
      print(e.toString());
      return AadharModel(true,e.toString());
      print(e);
    }
  }
  get_aadhar(String aadhar_id) async {

    try {





      Map<String, dynamic> respdata =
      await _aadharRepository.get(aadhar_id);

      return AadharModel(false,respdata['ad-no']);

      // Response.completed(chuckCats);
    } catch (e) {
      print(e);
      return AadharModel(true,e.toString());
    }
  }

}