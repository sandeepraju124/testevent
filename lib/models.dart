class EventData {
  final String eventname;
  final String date;
  final String userid;
  final int id;

  EventData({required this.eventname, required this.date, required this.userid , required this.id});

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      eventname: json['eventname'],
      date: json['date'],
      userid: json['userid'],
      id: json['id'],
    );
  }
}