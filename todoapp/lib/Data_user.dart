
// ignore_for_file: file_names

class DataUser{
  //data
  String? loginUser;
  String? password;
  String? name;
  String? phoneUser;
  String? refID;
  String? email;
  //..... them gia tri gi do

  //khoi tao dataUser
  DataUser(this.loginUser,this.name,this.password,this.phoneUser,this.email);

  //toJson
  Map<String,dynamic> toJson()=>_bookToJson(this);

}

Map<String,dynamic> _bookToJson(DataUser data) => 
  <String,dynamic>{
    'dataUser' : data.loginUser,
    'password' : data.password,
    'name' : data.name,
    'phoneUser' : data.phoneUser,
    'email' : data.email
};