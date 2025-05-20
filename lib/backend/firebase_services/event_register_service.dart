import 'package:cloud_firestore/cloud_firestore.dart';

class EventRegisterService {
   final FirebaseFirestore firestore=FirebaseFirestore.instance;
   
   Future<DocumentReference?> getDocByname(String event_name)async{
    try{
      final snapshot=await firestore.collection('ongoing_events').where('name',isEqualTo: event_name).limit(1).get();
      if(snapshot.docs.isNotEmpty){
        return snapshot.docs.first.reference;
      }
      else{
        return null;
      }
    }
    catch(e){
      throw Exception("Event not found");
    }
   }


   Future<List<Map<String,dynamic>>>  getTextFeilds(String event_name)async{
      try{
        final reference= await getDocByname(event_name);
        if(reference==null){
          throw Exception("Event not found");
        }
        final snapshot=await reference.get();
        final data= snapshot.data() as Map<String,dynamic>;
        final textfeilds=data['registrationTemplate'];
        List<Map<String,dynamic>> result=[];
        for(var feild in textfeilds){
          result.add(Map<String,dynamic>.from(feild));
        }
        return result;
      }
      catch(e){
        throw Exception(e.toString());
      }
   }

  

  Future<void> addData(Map<String,String> data,String event_name)async{
     final reference=await getDocByname(event_name);

     
     try{
        if(reference!=null){
          print("hi\n\n\n\n\n");
          await reference.collection('Registrations').doc(data['Team Name']).set(data);
          print("hi\n\n\n\n\n");
        }else{
          throw Exception("Can't find the document");
        }
     }catch(e){
          throw Exception(e.toString());
     }
  }
}