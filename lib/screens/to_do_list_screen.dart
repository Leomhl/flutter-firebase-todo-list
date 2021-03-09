import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/components/task_dismissible.dart';
import 'package:todolist/components/task_item.dart';
import 'package:todolist/models/task.dart';
import 'package:firebase_database/firebase_database.dart';

class ToDoListPage extends StatefulWidget {

  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  CalendarController _calendarController;

  final databaseReference = FirebaseDatabase(
      databaseURL: 'https://todo-list-a8b3c-default-rtdb.firebaseio.com/'
  ).reference();


  void initState() {
    super.initState();
    _calendarController = CalendarController();

    Future.delayed( Duration(milliseconds: 1000), () {
      selectedDay(null, null, null);
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  List<Task> tasks = List<Task>();

  String calendarToDate() {
    String selectedDate = _calendarController.selectedDay.toString().split(" ")[0];

    if(selectedDate == null) {
      DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      return dateToday.toString().split(" ")[0];
    }
    else {
        return _calendarController.selectedDay.toString().split(" ")[0];
    }
  }

  TextStyle dayStyle(FontWeight fontWeight) {
    return TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: fontWeight,
    );
  }

  void selectedDay(DateTime day, List events, List holidays) {

    databaseReference.child(calendarToDate()).once()
    .then((DataSnapshot snapshot) {

      setState(() {
        tasks = List<Task>();

        if (snapshot.value != null) {
          var dbTasks = Map<String, dynamic>.from(snapshot.value);

          dbTasks.forEach((date, task) {

            tasks.add(Task(title: task['title'],
                description: task['description'],
                done: task['done'],
                date: snapshot.key)
            );
          });
        }
      });
    });
  }

  void removeTask(index) {

    setState(() {
      databaseReference.child(calendarToDate())
      .child(tasks[index].title).remove();

      tasks.removeAt(index);
    });
  }

  void addTask(context) {
    TextEditingController _taskTitleController = TextEditingController();
    TextEditingController _taskDescriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
        scrollable: true,
        title: Text('Nova tarefa'),
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _taskTitleController,
                    validator: (value) {
                      return value.length == 0 ? 'Informe o título da tarefa' : null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Título',
                      icon: Icon(Icons.title),
                    ),
                  ),
                  TextFormField(
                    controller: _taskDescriptionController,
                    validator: (value) {
                      return value.length == 0 ? 'Descreva a tarefa' : null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      icon: Icon(Icons.description),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          RaisedButton(
            child: Text("Salvar"),
            onPressed: () {

              if(formKey.currentState.validate()) {

                databaseReference.child(calendarToDate())
                .child(_taskTitleController.text).set({
                  'title': _taskTitleController.text,
                  'description': _taskDescriptionController.text,
                  'done': false,
                });

                tasks.add(
                  Task(
                    title: _taskTitleController.text,
                    description: _taskDescriptionController.text,
                    date: calendarToDate(),
                  )
                );

                Navigator.of(context).pop();
              }
            }
          )
        ],
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 35),
              TableCalendar(
                onDaySelected: selectedDay,
                locale: 'pt_Br',
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  weekdayStyle: dayStyle(FontWeight.normal),
                  weekendStyle: dayStyle(FontWeight.normal),
                  selectedColor: Colors.blueGrey,
                  todayColor: Theme.of(context).primaryColor,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  weekdayStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                calendarController: _calendarController,
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: Theme.of(context).primaryColor,
                  ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Container(
                              width: (MediaQuery.of(context).size.width/3),
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top:20, left: 30),
                            child: Text("Hoje",
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: tasks.length > 0 ? ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                return TaskDismissible(
                                    onDismiss: () {
                                      removeTask(index);
                                    },
                                   taskItem: TaskItem(tasks[index])
                                );
                            // return Container();
                              },
                            ) : Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                "Nenhuma tarefa",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20,
                              ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50,)
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {addTask(context);},
        child: Icon(CupertinoIcons.add, color: Theme.of(context).accentColor),
        backgroundColor: Theme.of(context).buttonColor,
      ),
    );
  }
}
