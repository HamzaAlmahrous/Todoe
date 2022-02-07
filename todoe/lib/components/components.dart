// ignore: import_of_legacy_library_into_null_safe
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todoe/shared/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required final Function? function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: () => function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );
Widget defaultFormField1({
  required TextEditingController controller,
  required BuildContext context,
  required Function ontap,
  required String name,
  required IconData icon,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: TextInputType.datetime,
      onTap: () {
        ontap;
      },
      validator: (value) {
        String? content = value;
        if (content!.isEmpty) {
          return '$name must not be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Task $name',
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      readOnly: true,
    );

Widget defaultFormField({
  required TextEditingController? controller,
  required TextInputType? type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isPassword = false,
  bool readOnly = false,
  required Function validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: (value) => onSubmit,
      onChanged: (value) => onChange,
      onTap: () => onTap,
      validator: (value) {
        return validate(value);
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'quicksand'),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () => suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
      readOnly: readOnly,
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(1, 1),
                      blurRadius: 15.0,
                    )
                  ],
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    '${model['time']}',
                    style: const TextStyle(
                      shadows: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, 1),
                          blurRadius: 10.0,
                        )
                      ],
                      color: Color(0xFfD62121),
                      fontSize: 15.0,
                      fontFamily: 'quicksandbold',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      shadows: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 15.0,
                        )
                      ],
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: 'quicksand',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'].toString(),
                );
              },
              icon: const Icon(
                Icons.check_circle_outline,
                size: 30.0,
                color: Colors.greenAccent,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'archived',
                  id: model['id'].toString(),
                );
              },
              icon: const Icon(
                Icons.archive,
                size: 30.0,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(
          id: model['id'].toString(),
        );
      },
    );

Widget tasksBuilder({required List<Map> tasks}) {
  return ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder: (context) => ListView.separated(
      itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsetsDirectional.only(start: 20.0),
        child: Center(
          child: Container(
            width: 370.0,
            height: 2.0,
            color: Colors.grey,
          ),
        ),
      ),
      itemCount: tasks.length,
    ),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.menu,
            size: 100.0,
            color: Colors.grey,
          ),
          Text(
            'No Tasks Yet, Please Add Some Tasks',
            style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'quicksandbold',
                fontWeight: FontWeight.bold,
              ),
          )
        ],
      ),
    ),
  );
}
