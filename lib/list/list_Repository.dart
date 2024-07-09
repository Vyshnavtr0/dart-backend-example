import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tasklist_backend/hash_extension.dart';
part 'list_Repository.g.dart';

@visibleForTesting
Map<String, TaskList> listDb = {};

@JsonSerializable()
class TaskList extends Equatable {
  const TaskList({required this.id, required this.name});

  final String id;
  final String name;

  factory TaskList.fromJson(Map<String, dynamic> json) =>
      _$TaskListFromJson(json);

  Map<String, dynamic> toJson() => _$TaskListToJson(this);

  TaskList copyWith({
    String? id,
    String? name,
  }) {
    return TaskList(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class TaskListRepository {
  Future<TaskList?> listbyId(String id) async {
    return listDb[id];
  }

  Map<String, dynamic> getAllList() {
    final formattedLists = <String, dynamic>{};

    if (listDb.isNotEmpty) {
      listDb.forEach((String id) {
        final currentList = listDb[id];

        formattedLists?[id] = currentList?.toJson();
      } as void Function(String key, TaskList value));
    }

    return formattedLists;
  }

  String createList({required String name}) {
    String id = name.hashValue;

    final list = TaskList(id: id, name: name);

    listDb[id] = list;

    return id;
  }

  void deleteList(String id) {
    listDb.remove(id);
  }

  Future<void> updateList({required String id, required String name}) async {
    final currentlist = listDb[id];

    if (currentlist == null) {
      return Future.error(Exception("list not found"));
    }
    final list = TaskList(id: id, name: name);
    listDb[id] = list;
  }
}
