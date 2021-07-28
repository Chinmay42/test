part of 'artifect.dart';
class ArtifectAdapter extends TypeAdapter<Artifect> {
  @override
  Artifect read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Artifect(
      userId: fields[0] as String,
      artifectList: fields[1] as List,

    );
  }

  @override
  void write(BinaryWriter writer, Artifect obj)
  {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.artifectList);

  }

  @override
  int get typeId => 0;


}