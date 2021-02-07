import ballerina/io;
import ballerinax/kafka;
import ballerina/graphql;
import ballerina/docker;


kafka:ProducerConfiguration studentConfig = {
    bootstrapServers: "localhost:9092",
	clientId: "hfieProducer",
	acks: "all",
	retryCount: 3
};

@docker:Config { 
    name: "fieProd",
     tag: "v1.0"
     }
kafka:Producer prod = checkpanic new (studentConfig);

service graphql:Service /graphql on new graphql:Listener(8080){

    resource function get fieApprove(string Student_No,string approve)  returns string {

        //Application form object
         supForm form = {"message" :"applicatioaccepted attached id the interview time","studentNo":Student_No,"approve":approve};
         //change file status using the filename as key 
         string jsonFilePath = "./files/" +Student_No+".json";
         //read file
         json readJson = checkpanic io:fileReadJson(jsonFilePath);
         //make record a file
          map<json> application = <map<json>>readJson;
         application["FIE APPROVAL"] = "yes";
        //write updated file to json
         checkpanic io:fileWriteJson(jsonFilePath, application);

         byte[] serialisedMsg = Student_No.toString().toBytes();

       //call producer to send messages to a topic "candidateReg" 
             checkpanic prod->sendProducerRecord({
                                    topic: "fieapprovedproposal",
                                    value: serialisedMsg });

             checkpanic prod->flushRecords();
           // io:println();
        return "fie accepted " ;
    }

    // resource function get assignFIE(string Applicant_ID,string FIEID)  returns string {

    //     //Application form object
    //      supForm form = {"message" :"application accepted attached id the interview time","studentNo":Applicant_ID,"FIEID":FIEID};
    //      //change file status using the filename as key 
    //      string jsonFilePath = "./files/" +Applicant_ID+".json";
       
    //        //read file
    //      json readJson = checkpanic io:fileReadJson(jsonFilePath);
    //      //make record a file
    //       map<json> application = <map<json>>readJson;
    //       //check if assignment was approved by supervisor
    //         if ( application["app_status"] == "supervisor accepted"){
    //                     //assign FIE_ID
    //                     application["FIE_Assigned"] = FIEID;
    //                     //write updated file to json
    //                     checkpanic io:fileWriteJson(jsonFilePath, application);

                                
    //                         byte[] serialisedMsg = form.toString().toBytes();

    //                     //call producer to send messages to a topic "candidateReg" 
    //                             checkpanic prod->sendProducerRecord({
    //                                                     topic: "student_proposal",
    //                                                     value: serialisedMsg });

    //                             checkpanic prod->flushRecords();
                        
    //                 }else{

    //                 }
            
        

    //        // io:println();
    //     return "application accepted " ;
    // }

}

public type supForm record {
    string studentNo;
     string message;
    string approve;
};







