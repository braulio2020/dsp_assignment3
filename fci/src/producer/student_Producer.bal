import ballerina/io;
import ballerinax/kafka;
import ballerina/graphql;
import ballerina/docker;


kafka:ProducerConfiguration studentConfig = {
    bootstrapServers: "localhost:9092",
	clientId: "studentProducer",
	acks: "all",
	retryCount: 3
};

@docker:Config { 
    name: "studentProd",
     tag: "v1.0"
     }
kafka:Producer prod =checkpanic new (studentConfig);

service graphql:Service /graphql on new graphql:Listener(8082){

    resource function get studentProducerd(string name, string program,string Student_No,string contactNo)  returns string {
        //Application form object
        AppForm form = {"studentNo":Student_No,name,program, contactNo};
         string jsonFilePath = "./files/"+Student_No+" .json";
            json jsonContent = {"Store": {
                    "@id": 1,
                    "name": Student_No,
                    "program": program,
                    "contactNo": contactNo,
                    "app_status": "processing"
                }};
   //creating file 
       checkpanic io:fileWriteJson(jsonFilePath, jsonContent);
         byte[] serialisedMsg = form.toString().toBytes();

//call producer to send messages to a topic "candidateReg" 
             checkpanic prod->sendProducerRecord({
                                    topic: "application_form",
                                    value: serialisedMsg });

             checkpanic prod->flushRecords();
           // io:println();
        return "Candidate registered succesfully : " + name;
    }

//proposal
    resource function get studentProposal(string studentNo, string background,string probStat,string ScopeLimit)  returns string {
        //Application form object
        propForm form = {"studentNo":studentNo,"proposal":"proposal submitted"};
         string jsonFilePath = "./files/"+studentNo+".json";
            json jsonContent = {"studentNo": {
                    "@id":studentNo,
                    "background": background,
                    "probStat": probStat,
                    "ScopeLimit": ScopeLimit,
                    "app_status": "sent"
                    
                }};
   //creating file 
       checkpanic io:fileWriteJson(jsonFilePath, jsonContent);
         byte[] serialisedMsg = form.toString().toBytes();

//call producer to send messages to a topic "candidateReg" 
             checkpanic prod->sendProducerRecord({
                                    topic: "student_proposal",
                                    value: serialisedMsg });

             checkpanic prod->flushRecords();
           // io:println();
        return "proposal sent  " ;
    }


}

public type propForm record {
    string studentNo;
    string proposal;

};
public type AppForm record {
    string studentNo;
    string name;
    string program;
    string contactNo;
};






