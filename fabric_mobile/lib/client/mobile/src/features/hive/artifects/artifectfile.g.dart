part of 'artifectfile.dart';


class ArtifectFileAdapter extends TypeAdapter<ArtifectFile>
{
  @override
  ArtifectFile read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArtifectFile(
        artifectNumber:fields[0] as String,
        file: fields[1] as String,
        filePath: fields[2] as String,
        status: fields[3] as String,
      userId: fields[4] as String,
      fileFor: fields[5] as String,
     projectName: fields[6] as String,
     biometricHand: fields[7] as bool,
      biometricHandFinger: fields[8] as int,
   

    );
  }

  @override
  void write(BinaryWriter writer, ArtifectFile obj)
  {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.artifectNumber)
      ..writeByte(1)
      ..write(obj.file)
      ..writeByte(2)
      ..write(obj.filePath)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.fileFor)
      ..writeByte(6)
      ..write(obj.projectName)
      ..writeByte(7)
      ..write(obj.biometricHand)
      ..writeByte(8)
      ..write(obj.biometricHandFinger);
  }

  @override
  int get typeId => 2;


}