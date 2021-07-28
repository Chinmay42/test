part of 'ar_user.dart';


class ArtifectUserAdapter extends TypeAdapter<ArtifectUser>
{
  @override
  ArtifectUser read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArtifectUser(
      userId:fields[0] as String,

    );
  }

  @override
  void write(BinaryWriter writer, ArtifectUser obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.userId);



  }

  @override
  int get typeId => 3;


}