import ballerina/io;
import ballerinax/kafka;
import ballerina/graphql;
//import ballerina/http;


kafka:ProducerConfiguration studentConfig = {
    bootstrapServers: "localhost:9092",
	clientId: "hodProducer",
	acks: "all",
	retryCount: 3
};


kafka:Producer prod = checkpanic new (studentConfig);

service graphql:Service /graphql on new graphql:Listener(8085){

   
//accepting 
       resource function get acceptProposal(string Applicant_ID,string Response)  returns string {
        //Application form object
         supForm form = {"studentNo":Applicant_ID,"Response":Response};
         byte[] serialisedMsg = form.toString().toBytes();

           string jsonFilePath = "./files/" +Applicant_ID+".json";
         //read file
         json readJson = checkpanic io:fileReadJson(jsonFilePath);
         //make record a file
          map<json> application = <map<json>>readJson;
         application["app_status"] = "final submission";
        application["HDC Evaluation"]       =Response;
        //write updated file to json
         checkpanic io:fileWriteJson(jsonFilePath, application);

       //call producer to send messages to a topic "candidateReg" 
             checkpanic prod->sendProducerRecord({
                                    topic: "hdcapprovedproposal.",
                                    value: serialisedMsg });

             checkpanic prod->flushRecords();
           // io:println();
        return "application accepted " ;
    }






}

public type supForm record {
    string studentNo;
    // string message;
    string Response;
};

public type ASSForm record {
    string studentNo;
     string message;
    string FIEID;
};






