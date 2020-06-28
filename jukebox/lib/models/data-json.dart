class JsonData{

  final List<dynamic> data;


  JsonData({ this.data});

factory JsonData.fromJson(Map<String, dynamic> json){

  return JsonData(
    data: json['data'],
 
  );
 
}

}