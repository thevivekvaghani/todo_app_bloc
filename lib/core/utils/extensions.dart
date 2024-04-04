import 'package:intl/intl.dart';
import 'package:todo_app/data/enums/task_status.dart';
import 'package:todo_app/data/enums/task_status.dart';

extension StandardDate on DateTime {
  String toStandardDate() {
    return DateFormat('dd-MMM-yyyy').format(this);
  }
}

extension DateStatus on DateTime {
  String getCurrentStatus() {
    final today = DateTime.now();
    final tomorrow = DateTime.now().add(Duration(days: 1));
    if(day == today.day && month == today.month && year == today.year){
      return "Today";
    }else if(day == tomorrow.day && month == tomorrow.month && year == tomorrow.year){
      return "Tomorrow";
    }
    return toStandardDate();
  }
}


extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
          (Map<K, List<E>> map, E element) =>
      map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

extension TaskStatusExtension on String {
  TaskStatus getTaskStatus(){
    switch(this) {
      case "pending": {
        return TaskStatus.pending;
      }
      case "running": {
        return TaskStatus.running;
      }
      case "completed": {
        return TaskStatus.completed;
      }
      default: {
        return TaskStatus.pending;
      }
    }
  }
}
