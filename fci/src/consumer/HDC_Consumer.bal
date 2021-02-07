
import ballerinax/kafka;
import ballerina/docker;
import ballerina/log;
import ballerina/io;

//Consumer 1
kafka:ConsumerConfiguration consConf = {
    bootstrapServers: "localhost:9092",
    groupId: "hdc",

    topics: ["hdcapprovedproposal"],
    pollingIntervalInMillis: 1000, 
    //keyDeserializerType: kafka:DES_INT,
    //valueDeserializerType: kafka:DES_STRING,
    autoCommit: false
};



listener kafka:Listener cons = new (consConf);
@docker:Config { 
    name: "supervisorProd",
     tag: "v1.0"
}
service kafka:Service on cons {
    remote function onConsumerRecord(kafka:Caller caller,
                                kafka:ConsumerRecord[] records) {
        foreach var kafkaRecord in records {
            processKafkaRecord(kafkaRecord);
        }

        var commitResult = caller->commit();

        if (commitResult is error) {
            log:printError("Error occurred while committing the " +
                "offsets for the consumer ", err = commitResult);
        }
    }
}

function processKafkaRecord(kafka:ConsumerRecord kafkaRecord) {
    byte[] value = kafkaRecord.value;
    string|error messageContent = string:fromBytes(value);
    
    if (messageContent is string) {
        json|error jsonContent = messageContent.fromJsonString();

                if(jsonContent is json){
                    json|error stN = jsonContent.studentNumber;
                  

                    if(stN is json ){
                        string|error studentNumber = stN.toString();
                        
                         if(studentNumber  is string){
                            string jsonFilePath = "./files/" +studentNumber+".json";
                            //read file

                            json readJson = checkpanic io:fileReadJson(jsonFilePath);
                            io:println("***** view proposal ******");
                            io:println(readJson);
                         }
                      
                    }
                    
                }
       // log:print("Value: " + messageContent);
    } else {
        log:printError("Invalid value type received");
    }
}