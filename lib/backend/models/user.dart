class UserModel{
  final String? name;
  final String? email;
  final String? uid;


   UserModel({
    required this.name,
    required this.email,
    required this.uid
   });

  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'email':email,
      'uid':uid,
    };
  }


  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(
      name: map['name'], 
      email: map['email'],
      uid: map['uid']);
  }
}