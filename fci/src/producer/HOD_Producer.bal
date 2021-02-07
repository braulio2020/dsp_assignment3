import ballerina/io;
import ballerinax/kafka;
import ballerina/graphql;
import ballerina/docker;


kafka:ProducerConfiguration studentConfig = {
    bootstrapServers: "localhost:9092",
	clientId: "hodProducer",
	acks: "all",
	retryCount: 3
};
@docker:Config { 
    name: "hodProd",
     tag: "v1.0

kafka:Producer prod = checkpanic new (studentConfig);

service graphql:Service /graphql on new graphql:Listener(8084){

    resource function get interviewProducer(string Applicant_ID,string time)  returns string {

        //Application form object
         supForm form = {"message" :"application accepted attached id the interview time","studentNo":Applicant_ID,"time":time};
         //change file status using the filename as key 
         string jsonFilePath = "./files/" +Applicant_ID+".json";
         //read file
         json readJson = checkpanic io:fileReadJson(jsonFilePath);
         //make record a file
          map<json> application = <map<json>>readJson;
         application["app_status"] = "acceptedapplication";
        //write updated file to json
         checkpanic io:fileWriteJson(jsonFilePath, application);

         byte[] serialisedMsg = form.toString().toBytes();

       //call producer to send messages to a topic "candidateReg" 
             checkpanic prod->sendProducerRecord({
                                    topic: "student_proposal",
                                    value: serialisedMsg });

             checkpanic prod->flushRecords();
           // io:println();
        return "application accepted " ;
    }

    resource function get assignFIE(string Applicant_ID,string FIEID)  returns string {

        //Application form object
         ASSForm form = {"message" :"application accepted attached id the interview time","studentNo":Applicant_ID,"FIEID":FIEID};
         //change file status using the filename as key 
         string jsonFilePath = "./files/" +Applicant_ID+".json";
       
           //read file
         json readJson = checkpanic io:fileReadJson(jsonFilePath);
         //make record a file
          map<json> application = <map<json>>readJson;
          //check if assignment was approved by supervisor
          //  if ( application["app_status"] == "supervisor accepted"){
                        //assign FIE_ID
                        application["FIE_Assigned"] = FIEID;
                        //write updated file to json
                        checkpanic io:fileWriteJson(jsonFilePath, application);

                                
                            byte[] serialisedMsg = form.toString().toBytes();

                        //call producer to send messages to a topic "candidateReg" 
                                checkpanic prod->sendProducerRecord({
                                                        topic: "student_proposal",
                                                        value: serialisedMsg });

                                checkpanic prod->flushRecords();
                        
                   // }else{

                   // }
            
        

           // io:println();
        return "application accepted " ;
    }

}

public type supForm record {
    string studentNo;
     string message;
    string time;
};

public type ASSForm record {
    string studentNo;
     string message;
    string FIEID;
};






