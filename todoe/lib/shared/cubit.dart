import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoe/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todoe/modules/done_tasks/done_tasks_screen.dart';
import 'package:todoe/modules/new_tasks/new_tasks_scrren.dart';
import 'package:todoe/shared/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  late Database database;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.add;

  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomBarState());
  }

  //create database
  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database is Created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) => print('Table is Created'));
      },
      onOpen: (database) {
        getDateFormDatabase(database);
        print('Database Is Opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabseState());
    });
  }

  //insert to database
  insertToDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time, status) VALUES("$title","$date", "$time", "new")')
          .then((value) {
        emit(AppInsetDatabseState());

        getDateFormDatabase(database);
      }).catchError((error) {
        print('${error.toString()}');
      });
    });
  }

  //get data from database
  getDateFormDatabase(Database database) async {
    newTasks.clear();
    doneTasks.clear();
    archivedTasks.clear();
    emit(AppGetDatabseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      for (var element in value) {
        if (element['status'] == 'done') {
          doneTasks.add(element);
        } else if (element['status'] == 'new') {
          newTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      }
      emit(AppGetDatabseState());
    });
  }

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppShowBottomSheetState());
  }

  void updateData({required String status, required String id}) async {
    await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDateFormDatabase(database);
      emit(AppUpadateDatabseState());
    });
  }

  void deleteData({required String id}) async {
    await database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDateFormDatabase(database);
      emit(AppDeleteDatabseState());
    });
  }
}
