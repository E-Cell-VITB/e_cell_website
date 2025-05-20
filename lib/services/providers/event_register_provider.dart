import 'package:e_cell_website/backend/firebase_services/event_register_service.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:flutter/material.dart';

class EventRegisterProvider extends ChangeNotifier{
  final EventRegisterService _eventRegisterService=EventRegisterService();

  
  List<Map<String,dynamic>> _textfeilds=[];
  List<Map<String,dynamic>> get textfeilds=>_textfeilds;

  String? _errormessage;
  String? get errormessage=> _errormessage;

  //get regestration feild
  Future<List<Map<String,dynamic>>> displayTextFeilds(String event_name) async{
      try{
        _errormessage=null;
        _textfeilds=await _eventRegisterService.getTextFeilds(event_name);
      }catch(e){
        _errormessage=e.toString();
      }      
      notifyListeners();
      return _textfeilds;
  }
  
  Future<void> Register(String event_name,Map<String,String> data)async{
    print("hello\n\n\n\n\n");
     await _eventRegisterService.addData(data, event_name);
     print("hello2\n\n\n\n\n");
     showCustomToast(title: "Success", description: "Registered Successfuly");
    notifyListeners();

  }

}