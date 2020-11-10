class ApplyClass {
  int id;
  String name;
  String hospitalName;
  String jobTitle;
  String expertise;
  String contact;
  int approvalStatus;
  String userName;

  static ApplyClass fromMap(Map<String, dynamic> map) {
    if(map == null) return null;
    ApplyClass applyClass = ApplyClass();
    applyClass.id = map["id"];
    applyClass.name = map["name"];
    applyClass.hospitalName = map["hospitalName"];
    applyClass.jobTitle = map["jobTitle"];
    applyClass.expertise = map["expertise"];
    applyClass.contact = map["contact"];
    applyClass.approvalStatus = map["approvalStatus"];
    applyClass.userName = map["userName"];
    return applyClass;
  }

  Map tojson() => {
    "id": id,
    "name": name,
    "hospitalName": hospitalName,
    "jobTitle": jobTitle,
    "expertise": expertise,
    "contact": contact,
    "approvalStatus": approvalStatus,
    "userName": userName,
  };
}