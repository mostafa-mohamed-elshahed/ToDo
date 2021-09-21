import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoappabdullahmansor/shared/components/components.dart';
import 'package:todoappabdullahmansor/shared/cubit/cubit.dart';
import 'package:todoappabdullahmansor/shared/cubit/cubit_state.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(builder: (context,state)
    {
      var tasks =AppCubit.get(context).doneTasks;
      return tasksBuilder(
          tasks: tasks,context: context

      );
    },listener: (context,state){}
    );
  }
}
