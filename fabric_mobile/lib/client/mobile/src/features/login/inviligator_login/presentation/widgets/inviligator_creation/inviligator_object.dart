class InviligaltorPojo {
  String name;
  String id;
  String mobileNo;
  int loginDuration;
  InviligaltorPojo(this.name, this.id, this.mobileNo, this.loginDuration);

  Map toJson() => {
        'name': name,
        'id': id,
        'mobileNo': mobileNo,
        'loginDuration': loginDuration
      };
}
