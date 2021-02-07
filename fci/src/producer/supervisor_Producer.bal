import ballerina/io;
import ballerinax/kafka;
import ballerina/graphql;
import ballerina/docker;




kafka:ProducerConfiguration studentConfig = {
    bootstrapServers: "localhost:9092",
	clientId: "supervisorProducer",
	acks: "all",
	retryCount: 3
};
@docker:Config { 
    name: "supervisorProd",
     tag: "v1.0" 
     }

kafka:Producer prod =checkpanic new (studentConfig);

service graphql:Service /graphql on new graphql:Listener(8083){

    resource function get supervisorProducerd(string Applicant_ID,string supervisorID)  returns string {
        //Application form object
         supForm form = {"studentNo":Applicant_ID,"applicantID":supervisorID};
         byte[] serialisedMsg = form.toString().toBytes();

       //call producer to send messages to a topic "candidateReg" 
             checkpanic prod->sendProducerRecord({
                                    topic: "accepted_application",
                                    value: serialisedMsg });

             checkpanic prod->flushRecords();
           // io:println();
        return "application accepted " ;
    }
//accepting 
       resource function get acceptProposal(string Applicant_ID,string supervisorID,string Response)  returns string {
        //Application form object
         supForm form = {"studentNo":Applicant_ID,"applicantID":supervisorID};
         byte[] serialisedMsg = form.toString().toBytes();

           string jsonFilePath = "./files/" +Applicant_ID+".json";
         //read file
         json readJson = checkpanic io:fileReadJson(jsonFilePath);
         //make record a file
          map<json> application = <map<json>>readJson;
         application["app_status"] = "supervisor approved";
        application["comment"]       =Response;
        //write updated file to json
         checkpanic io:fileWriteJson(jsonFilePath, application);

       //call producer to send messages to a topic "candidateReg" 
             checkpanic prod->sendProducerRecord({
                                    topic: "accepted_application",
                                    value: serialisedMsg });

             checkpanic prod->flushRecords();
           // io:println();
        return "application accepted " ;
    }

}

public type supForm record {
    string studentNo;
   
    string applicantID;
};







