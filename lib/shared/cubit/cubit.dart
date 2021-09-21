import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoappabdullahmansor/modules/archived_tasks/archived_tasks.dart';
import 'package:todoappabdullahmansor/modules/done_taskes/done_tasks.dart';
import 'package:todoappabdullahmansor/modules/new_tasks/new_tasks.dart';
import 'package:todoappabdullahmansor/shared/cubit/cubit_state.dart';

class AppCubit extends Cubit<AppState>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context)=>BlocProvider.of(context);

  int currentIndex=0;
  Database dataBase;
  bool switcher = true;
  IconData switcherIcon = Icons.edit;

  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];
  List<String> title=[
    "NewTasks",
    "DoneTasks",
    "ArchivedTasks",
  ];
  final List<Widget> screens=[
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  void changeIndexState(int index){
    currentIndex=index;
    emit(ChangeCurrentStateBotNavBar());
  }
  void createDataBase()  {
     openDatabase("TODO.db", version: 1,
        onCreate: (dataBase, version) {
          print("DataBase Created ");
          dataBase
              .execute(
              "CREATE TABLE tasks(id INTEGER PRIMARY KEY ,title TEXT ,date TEXT, time TEXT , status TEXT)")
              .then((value) => {print("Table is created")})
              .catchError((onError) {
            print("THE ERROR IS ${onError.toString()}");
          });
        }, onOpen: (dateBase) {
          getFromDataBase(dateBase);
        }).then((value)=> {
          dataBase=value,
          emit(AppCreateDataBaseState()),
        });
  }
    insertDataBase({@required String title, @required String time, @required String date,}) async {
 await dataBase.transaction((txn) {
      txn
          .rawInsert(
          "INSERT INTO tasks(title,time,date,status) VALUES('$title','$time','$date','new')")
          .then((value) =>{
            print("$value is created"),
            emit(AppInitialState()),
            getFromDataBase(dataBase)
          })
          .catchError((onError) {
        print("${onError.toString()} that is the error");
      });
      return null;
    });
  }
  void getFromDataBase(dataBase)   {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    dataBase.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach((element){
        if(element["status"]== "new")
          newTasks.add(element);
        else if(element["status"]== "done")
          doneTasks.add(element);
        else archivedTasks.add(element);

      });
      emit(AppGetDataBaseState());
    });
  }
void changeBottomSheetState({@required IconData icon, @required bool isShow})
{
  switcher = isShow;
  switcherIcon =icon;
  emit(ChangeBottomSheetState());
}
void upDateData({String status, int id}){
       dataBase.rawUpdate(
           'UPDATE tasks SET status = ? WHERE id = ?',
           ['$status',id]).then((value) {
        getFromDataBase(dataBase);
        emit(AppUpDateDataBaseState());
       });
      }
void deleteDateBase({@required int id}){
  dataBase
      .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
    emit(AppDeleteDataBaseState());
    getFromDataBase(dataBase);
  });
  }
}