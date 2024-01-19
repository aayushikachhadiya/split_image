import 'package:hive/hive.dart';
part 'adapter.g.dart';
@HiveType(typeId: 0)
class controller extends HiveObject
{
  @HiveField(0)
  String name;

  @HiveField(1)
  String contect;
  controller(this.name,this.contect);

  @override
  String toString() {
    return 'controller{name: $name, contect: $contect}';
  }
}