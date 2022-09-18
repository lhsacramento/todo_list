class Todo{
  Todo({required this.title, required this.dateTime, required this.color});
  Todo.fromJson(Map<String,dynamic> json) : title = json['title'],
                                            dateTime = DateTime.parse(json['dateTime']),
                                            color = int.parse(json['color']);

  String title;
  DateTime dateTime;
  int color;

  Map<String,dynamic> toJson(){
    return{
      'title' : title,
      'dateTime' : dateTime.toString(),
      'color' : color.toString(),
    };
  }

  Todo toTodo(Map<String,dynamic> map){
    return Todo(
      title: map[title],
      dateTime: map[dateTime],
      color: map[color],
    );
  }
}