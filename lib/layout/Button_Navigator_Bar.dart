import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoappabdullahmansor/shared/components/components.dart';
import 'package:todoappabdullahmansor/shared/cubit/cubit.dart';
import 'package:todoappabdullahmansor/shared/cubit/cubit_state.dart';

class Hello extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class  HomeLayout extends StatelessWidget {


  var textController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if(state is AppInitialState) {
          Navigator.pop(context);
        }
      },
        builder: (context, state)
        {
          AppCubit cubit = AppCubit.get(context);
              return Scaffold(
                  key: scaffoldKey,
                  appBar: AppBar(
                    title: Text(
                      cubit.title[cubit.currentIndex],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    backgroundColor: Colors.orange[800],
                    elevation: 12,
                  ),
                  body: cubit.screens[cubit.currentIndex],
                  bottomNavigationBar: BottomNavigationBar(
                      backgroundColor: Colors.orange[800],
                      selectedItemColor: Colors.black,
                      unselectedItemColor: Colors.black54,
                      currentIndex: cubit.currentIndex,
                      onTap: (index) {
                        cubit.changeIndexState(index);
                      },
                      iconSize: 30,
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.add_circle),
                          label: "New Tasks",
                        ),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.done), label: "Done Tasks"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.archive_outlined),
                            label: "Archive Tasks"),
                      ]),
                  floatingActionButton: FloatingActionButton(
                    elevation: 15,
                    backgroundColor: Colors.white38,
                    onPressed: () {
                      if (cubit.switcher == true) {
                        scaffoldKey.currentState
                            .showBottomSheet((context) {
                              return Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(20),
                                        width: double.infinity,
                                        height: 100,
                                        child: defaultTextFromField(
                                            onSubmit: (value) {
                                              textController?.text = value;
                                              print(value.toString());
                                            },
                                            textEditingController:
                                                textController,
                                            textInputType: TextInputType.text,
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return "Value Most Be Empty";
                                              }
                                              return null;
                                            },
                                            label: "Title",
                                            prefix: Icons.text_fields,
                                            suffix: null)),
                                    Container(
                                        padding: EdgeInsets.all(20),
                                        width: double.infinity,
                                        height: 100,
                                        child: defaultTextFromField(
                                            onTap: () {
                                              showTimePicker(
                                                      context: (context),
                                                      initialTime:
                                                          TimeOfDay.now())
                                                  .then((value) {
                                                print(value);
                                                timeController.text =
                                                    value.format(context);
                                              }).catchError((onError) {
                                                print(onError.toString());
                                              });
                                            },
                                            textEditingController:
                                                timeController,
                                            textInputType:
                                                TextInputType.datetime,
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return "Value Most Be Empty";
                                              }
                                              return null;
                                            },
                                            label: "Time Date",
                                            prefix: Icons.watch_later,
                                            suffix: null)),
                                    Container(
                                        padding: EdgeInsets.all(20),
                                        width: double.infinity,
                                        height: 100,
                                        child: defaultTextFromField(
                                            onTap: () {
                                              showDatePicker(
                                                      context: (context),
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime.parse(
                                                          "2025-05-05"))
                                                  .then((value) {
                                                print(value);
                                                dateController.text =
                                                    DateFormat.yMMMd()
                                                        .format(value);
                                              }).catchError((onError) {
                                                print(onError.toString());
                                              });
                                            },
                                            textEditingController:
                                                dateController,
                                            textInputType:
                                                TextInputType.datetime,
                                            validate: (String value) {
                                              if (value.isEmpty) {
                                                return "Value Most Be Empty";
                                              }
                                              return null;
                                            },
                                            label: "DateTime",
                                            prefix: Icons.calendar_today,
                                            suffix: null)),
                                  ],
                                ),
                              );
                            }, elevation: 15)
                            .closed
                            .then((value) {
                          cubit.changeBottomSheetState(
                            icon: Icons.edit,
                            isShow: true,
                          );
                            });
                        cubit.changeBottomSheetState(
                          icon: Icons.add,
                          isShow: false,
                        );
                      } else {
                        if (formKey.currentState.validate()) {
                          cubit.insertDataBase(
                            time: timeController.text,
                            title: textController.text,
                            date: dateController.text,
                          )
                          //     .then((value) => {
                          //       Navigator.pop(context),
                          // cubit.changeBottomSheetState(
                          //   icon: Icons.edit,
                          //   isShow: true,),
                          //     }
                          //     )
                              ;
                        }
                      }
                    },
                    child: Icon(cubit.switcherIcon),
                  ),
                );
              }),
    );
  }
}
