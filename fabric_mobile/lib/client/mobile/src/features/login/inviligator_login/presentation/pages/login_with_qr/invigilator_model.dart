//in as Invigilator
class InvigilatorModel
{
   String inImage;
   String inName;
   String inIdNumber;
   String inPhoneNo;
   int invLoginDuration;
   String inIdProofName;
   String inIdProofImage;
   String inQRImage;
   String cpId;
   String examId;
   @override
  String toString() {
    // TODO: implement toString
    return ' $inImage $inName $inIdNumber  $inPhoneNo $invLoginDuration $inIdProofName,$inIdProofImage $inQRImage $cpId $examId';
  }

   InvigilatorModel(
       {this.inImage,
         this.inName,
         this.inIdNumber,
         this.inPhoneNo,
         this.invLoginDuration,
         this.inIdProofName,
         this.inIdProofImage,
         this.inQRImage,
         this.cpId,
         this.examId});


   Map<String, dynamic> toJson()=>
       {
         "inImage":inImage,
         "inName":inName,
         "inIdNumber":inIdNumber,
         "inPhoneNo":inPhoneNo,
         "invLoginDuration":invLoginDuration,
         "inIdProofName":inIdProofName,
         "inIdProofImage":inIdProofImage,
         "inQRImage":inQRImage,
         "cpId":cpId,
         "examId":examId
       };

   factory InvigilatorModel.fromJson(dynamic json)
   {
     InvigilatorModel invigilatorModel = new InvigilatorModel();
     invigilatorModel.inImage = json['inImage'];
     invigilatorModel.inName = json['inName'];
     invigilatorModel.inIdNumber = json['inIdNumber'];
     invigilatorModel.inPhoneNo = json['inPhoneNo'];
     invigilatorModel.invLoginDuration = json['invLoginDuration'];
     invigilatorModel.inIdProofName = json['inIdProofName'];
     invigilatorModel.inIdProofImage = json['inIdProofImage'];
     invigilatorModel.inQRImage = json['inQRImage'];
     invigilatorModel.cpId = json['cpId'];
     invigilatorModel.examId = json['examId'];

     return invigilatorModel;
   }
}

