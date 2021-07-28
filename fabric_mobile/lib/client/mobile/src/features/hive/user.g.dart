part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************



class UserAdapter extends TypeAdapter<UserDetail> {
  @override
  UserDetail read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDetail(
        userId: fields[0] as String,
        userName: fields[1] as String,
        userMobileNumber: fields[2] as String,
        otherDetails: fields[3] as String
    );
  }

  @override
  void write(BinaryWriter writer, UserDetail obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.userMobileNumber)
      ..writeByte(3)
      ..write(obj.otherDetails);
  }

  @override
  // TODO: implement typeId
  int get typeId => 1;


}