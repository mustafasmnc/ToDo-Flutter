import 'package:flutter/material.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  bool isExpanded = false;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin<MyHomePage> {
  static List allDates = [
    {
      "id":"1",
      "date": DateTime.now(),
      "startTime": "09:00",
      "endTime": "11:00",
      "subject": "Science",
      "content":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras molestie sapien id nisl bibendum, vitae convallis odio interdum. Fusce tristique auctor augue, et vulputate augue molestie egestas.",
      "teacher": "Cartman",
      "imageUrl":
          "https://vignette.wikia.nocookie.net/southpark/images/6/61/Formal-cartman.png/revision/latest?cb=20170805025742",
    },
    {
      "id":"2",
      "date": DateTime.now().subtract(Duration(days: 2)),
      "startTime": "09:30",
      "endTime": "11:30",
      "subject": "English",
      "content":
          "Fusce id ultrices nisl. Nam congue elementum viverra. Integer facilisis mi sed sapien accumsan, in vulputate sapien ultricies. Nunc non cursus dui.",
      "teacher": "Diane",
      "imageUrl":
          "https://vignette.wikia.nocookie.net/southpark/images/8/88/DianeChokdondik_Transparent.png/revision/latest?cb=20170112013733",
    },
    {
      "id":"3",
      "date": DateTime.now().add(Duration(days: 4)),
      "startTime": "12:30",
      "endTime": "14:00",
      "subject": "Music",
      "content":
          "Mauris ornare molestie leo eu imperdiet. Maecenas semper, lectus et consectetur mollis, mi justo porta neque, at posuere tellus sapien cursus lectus.",
      "teacher": "Richard",
      "imageUrl":
          "https://vignette.wikia.nocookie.net/southpark/images/e/e0/Mr-adler.png/revision/latest/top-crop/width/360/height/450?cb=20171011070726",
    }
  ];

  DateTime startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime endDate = DateTime.now().add(Duration(days: 30));
  DateTime selectedDate = DateTime.now();
  List<DateTime> markedDates = [];
  List datesData = [];

  onSelect(data) {
    setState(() {
      datesData.clear();
      for (int i = 0; i < allDates.length; i++) {
        if (DateTime.parse(DateFormat('yyy-MM-dd').format(data)) !=
            DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()))) {
          widget.isExpanded = false;
        }
      }
    });

    print("Selected Date -> $data");

    for (int i = 0; i < allDates.length; i++) {
      if (DateTime.parse(DateFormat('yyy-MM-dd').format(data)) ==
          DateTime.parse(
              DateFormat('yyyy-MM-dd').format(allDates[i]['date']))) {
        setState(() {
          datesData.add(allDates[i]);
        });
      }
    }
  }

  _monthNameWidget(monthName) {
    return Container(
      child: Text(
        monthName,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontStyle: FontStyle.italic,
        ),
      ),
      padding: EdgeInsets.only(top: 8, bottom: 4),
    );
  }

  getMarkedIndicatorWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        margin: EdgeInsets.only(left: 1, right: 1),
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      ),
      Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
      )
    ]);
  }

  dateTileBuilder(
      date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    Color fontColor = isDateOutOfRange ? Colors.white : Colors.white70;
    TextStyle normalStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w800,
      color: fontColor,
    );
    TextStyle selectedStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w800,
      color: Colors.white,
    );
    TextStyle dayNameStyle = TextStyle(
      fontSize: 14.5,
      color: fontColor,
    );
    List<Widget> _children = [
      Text(dayName, style: dayNameStyle),
      Text(date.day.toString(),
          style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    if (isDateMarked == true) {
      _children.add(getMarkedIndicatorWidget());
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 10),
      decoration: BoxDecoration(
        //color: !isSelectedDate ? Colors.transparent : Color(0xFF00EBD6),
        border: !isSelectedDate ? null : Border.all(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Column(
        children: _children,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < allDates.length; i++) {
      setState(() {
        markedDates.add(allDates[i]['date']);

        if (DateTime.parse(DateFormat('yyy-MM-dd').format(DateTime.now())) ==
            DateTime.parse(
                DateFormat('yyyy-MM-dd').format(allDates[i]['date']))) {
          datesData.add(allDates[i]);
        }
      });
    }
  }

  deleteNote(String noteID){
    print(noteID);
  } 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Center(child: Text('Todo')),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    const Color(0xFF3366FF),
                    const Color(0xFFAC256D),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
        ),
        body: ListView(
          children: [
            Container(
                child: CalendarStrip(
              containerHeight: 105,
              startDate: startDate,
              endDate: endDate,
              onDateSelected: onSelect,
              dateTileBuilder: dateTileBuilder,
              iconColor: Colors.white,
              monthNameWidget: _monthNameWidget,
              markedDates: markedDates,
              containerDecoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      const Color(0xFF3366FF),
                      const Color(0xFFAC256D),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            )),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: datesData.length,
                itemBuilder: (BuildContext context, i) {
                  return ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Row(
                        children: [
                          SizedBox(height: 50),
                          SizedBox(
                            height: 15,
                            width: 30,
                            child: Container(
                              child: Material(
                                color: Colors.orange,
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.zero,
                                    right: Radius.circular(60)),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              datesData[i]['startTime'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 150),
                            child: Text(
                              datesData[i]['endTime'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: widget.isExpanded ? 220 : 175,
                        padding: EdgeInsets.only(left: 30, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: new LinearGradient(
                                colors: [
                                  const Color(0xFF3366FF),
                                  const Color(0xFFAC256D),
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Subject: ${datesData[i]['subject']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {deleteNote(datesData[i]['id']);}),
                                            IconButton(
                                                icon: Icon(Icons.edit,
                                                    color: Colors.white),
                                                onPressed: () {})
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 15),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: ClipOval(
                                          child: Image.network(
                                            datesData[i]['imageUrl'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Teacher: ${datesData[i]['teacher']}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: widget.isExpanded ? 130 : 85,
                                  //color: Colors.red,
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new AnimatedSize(
                                            vsync: this,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            child: new ConstrainedBox(
                                                constraints: widget.isExpanded
                                                    ? new BoxConstraints()
                                                    : new BoxConstraints(
                                                        maxHeight: 30.0),
                                                child: new Text(
                                                  widget.isExpanded
                                                      ? datesData[i]['content']
                                                      : datesData[i]['content']
                                                          .substring(0, 50),
                                                  softWrap: true,
                                                  overflow: TextOverflow.fade,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))),
                                        widget.isExpanded
                                            ? new ConstrainedBox(
                                                constraints:
                                                    new BoxConstraints())
                                            : new FlatButton(
                                                child: const Text(
                                                  '...',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () => setState(() =>
                                                    widget.isExpanded = true))
                                      ]),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
