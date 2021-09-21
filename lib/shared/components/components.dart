import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:todoappabdullahmansor/shared/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.grey,
  bool isUpperCase =true,
  double radius =3.0,
  @required Function function,
  @required String text,
})=>Container(
  width: width,
  child: MaterialButton(
    onPressed: function,
    height: 40,
    child: Text(isUpperCase ? text.toUpperCase() :text ,
    style: TextStyle(
      color: Colors.white,
    ),
    ),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
);


Widget defaultTextFromField({
  @required TextEditingController textEditingController,
  @required TextInputType textInputType,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  @required IconData suffix,
  Function onTap,
  Function onSubmit,
  Function onChange,
  bool isPassword =false,
  bool enabledToOpenKeyboard =true,
}) => TextFormField(
  onTap: onTap,
  controller: textEditingController,
  keyboardType: textInputType,
  obscureText: isPassword,
  enabled: enabledToOpenKeyboard,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  validator: validate,
  // (String نضع نوع استرنج حتي يتيح لنا اختيار ايز إمتي  value){if(value isEmpty){return ""}return null; }
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(prefix),
    suffixIcon: suffix !=null ? Icon(suffix) : null,
    border: OutlineInputBorder(),
  ),
);

Widget itemBuilderForTasks(Map model,context)=> Dismissible(
    key: Key(model["id"].toString()),
    onDismissed: (direction){
    AppCubit.get(context).deleteDateBase(id: model["id"]);
    },
   child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(radius: 40,backgroundColor: Colors.orange,child: Padding(

          padding: const EdgeInsets.only(left:16.0),

          child: Text(model["date"].toString(),style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold,),),

        ),),

        Expanded(

          child: Padding(

            padding: const EdgeInsets.only(left:8.0),



              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(model["title"].toString(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),),

                  Text(model["time"].toString(),style: TextStyle(fontSize: 15,color: Colors.grey,),),

                ],

              ),

            ),

        ),



        IconButton(onPressed: (){AppCubit.get(context).upDateData(status: "archived", id:model["id"]);}, icon: Icon(Icons.archive)),

        IconButton(onPressed: (){AppCubit.get(context).upDateData(status:"done",id: model["id"]);}, icon: Icon(Icons.check_circle_sharp)),

      ],

    ),

  ),
    );
Widget tasksBuilder({@required List<Map> tasks,@required context})=> Conditional.single(
    context: context,
    conditionBuilder:(context) => tasks.length>0,
    widgetBuilder:(context)=> ListView.separated(
        itemBuilder: (context, index) => itemBuilderForTasks(tasks[index],context),
        separatorBuilder: (context, index) =>
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            ),
        itemCount: tasks.length),
    fallbackBuilder:(context)=> Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [
        Text("   No Tasks Founded \nPlease Enter SomeTasks",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
      ],),
) );