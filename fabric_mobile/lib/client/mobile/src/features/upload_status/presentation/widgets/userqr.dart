class UserQR {
  String name;
  String registrationNumber;
  String venueName;
  String idProof;
  String batchTiming;
  String fathersName;
  String communicationAddress;
  String contactNumber;
  String labNo;

  UserQR(
      {this.name,
      this.registrationNumber,
      this.venueName,
      this.idProof,
      this.batchTiming,
      this.fathersName,
      this.communicationAddress,
      this.contactNumber,
      this.labNo});
  Map toJson() => {
        'name': name,
        'registrationNumber': registrationNumber,
        'venueName': venueName,
        'iDProof': idProof,
        'batchTiming': batchTiming,
        'labNo' : labNo,
        'fathersName': fathersName,
        'communicationAddress': communicationAddress,
        'contactNumber': contactNumber,
      };

  factory UserQR.fromJson(dynamic json) {
    return UserQR(
      name: json['name'] as String,
      registrationNumber: json['registrationNumber'].toString(),
      venueName: json['venueName'].toString(),
      idProof: json['iDProof'].toString(),
      batchTiming: json['batchTiming'].toString(),
      labNo: json['labNo'].toString(),
      fathersName: json['fathersName'].toString(),
      communicationAddress: json['communicationAddress'].toString(),
      contactNumber: json['contactNumber'].toString(),
    );
  }
}
