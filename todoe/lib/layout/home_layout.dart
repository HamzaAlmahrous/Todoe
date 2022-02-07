// ignore_for_file: import_of_legacy_library_into_null_safe, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todoe/shared/states.dart';
import 'package:todoe/shared/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoe/components/components.dart';
import 'package:todoe/components/popup_card.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'dart:core';
import 'package:intl/intl.dart';

// 1. creat databasse
// 2. creat tables
// 3. open database
// 4. insert to database
// 5. get from database
// 6. upgrade in database
// 7. delete from database

class HomeLayout extends StatelessWidget {
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsetDatabseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              centerTitle: true,
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              splashColor: Colors.red,
              hoverColor: Colors.black,
              hoverElevation: 10.0,
              backgroundColor: Colors.white54,
              elevation: 100.0,
              onPressed: () {
                final popup = BeautifulPopup.customize(
                  context: context,
                  build: (options) => MyTemplate(options),
                );
                popup.show(
                  title: 'New Task',
                  content: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFFA5A6F6),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35.0),
                        )),
                    padding: const EdgeInsets.all(
                      20.0,
                    ),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(
                            controller: titleController,
                            type: TextInputType.text,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'title must not be empty';
                              }
                              return null;
                            },
                            label: 'Task Title',
                            prefix: Icons.title,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            controller: dateController,
                            keyboardType: TextInputType.datetime,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2024-05-03'),
                              ).then((value) async {
                                dateController.text =
                                    DateFormat.yMMMd().format(value!);
                              });
                            },
                            validator: (value) {
                              String? content = value;
                              if (content!.isEmpty) {
                                return 'date must not be empty';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Task Date',
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            controller: timeController,
                            keyboardType: TextInputType.datetime,
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) async {
                                timeController.text = value!.format(context);
                              });
                            },
                            validator: (value) {
                              String? content = value;
                              if (content!.isEmpty) {
                                return 'time must not be empty';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Task Time',
                              prefixIcon: Icon(Icons.watch_outlined),
                              border: OutlineInputBorder(),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                  actions: [

                    popup.button(
                      label: 'enter',
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          cubit.insertToDatabase(
                            title: titleController.text,
                            time: timeController.text,
                            date: dateController.text,
                          );
                          titleController.clear();
                          timeController.clear();
                          dateController.clear();
                        }
                      },
                    ),
                  ],
                );
              },
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              child: Icon(
                cubit.fabIcon,
                color: Colors.white,
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, spreadRadius: 3, blurRadius: 100),
                ],
              ),
              height: 90.0,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(35.0),
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: cubit.currentIndex,
                  onTap: (index) {
                    cubit.changeIndex(index);
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list),
                      label: 'Tasks',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.check_sharp,
                      ),
                      label: 'Done',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined),
                      label: 'Archived',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
