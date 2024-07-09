import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tasklist_backend/hash_extension.dart';
part 'item_Repository.g.dart';

@visibleForTesting
Map<String, TaskItem> itemDb = {};

@JsonSerializable()
class TaskItem extends Equatable {
  const TaskItem(
      {required this.id,
      required this.listid,
      required this.description,
      required this.status,
      required this.name});

  final String id;
  final String listid;
  final String name;
  final String description;
  final bool status;

  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);

  Map<String, dynamic> toJson() => _$TaskItemToJson(this);

  TaskItem copyWith({
    String? id,
    String? name,
    String? listid,
    String? description,
    bool? status,
  }) {
    return TaskItem(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        status: status ?? this.status,
        listid: listid ?? this.listid);
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class TaskItemRepository {
  Future<TaskItem?> itembyId(String id) async {
    return itemDb[id];
  }

  Map<String, dynamic> getAllItems() {
    final formattedLists = <String, dynamic>{};

    if (itemDb.isNotEmpty) {
      itemDb.forEach((String id) {
        final currentList = itemDb[id];

        formattedLists?[id] = currentList?.toJson();
      } as void Function(String key, TaskItem value));
    }

    return formattedLists;
  }

  String createItem(
      {required String name,
      required String listid,
      required String description,
      required bool status}) {
    String id = name.hashValue;

    final list = TaskItem(
        id: id,
        name: name,
        listid: listid,
        description: description,
        status: status);

    itemDb[id] = list;

    return id;
  }

  void deleteItems(String id) {
    itemDb.remove(id);
  }

  Future<void> updateList(
      {required String id,
      required String name,
      required String listid,
      required String description,
      required bool status}) async {
    final currentlist = itemDb[id];

    if (currentlist == null) {
      return Future.error(Exception("item not found"));
    }
    final list = TaskItem(
        id: id,
        name: name,
        description: description,
        status: status,
        listid: listid);
    itemDb[id] = list;
  }
}
