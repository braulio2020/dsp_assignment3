
import ballerinax/kafka;
//import ballerina/lang.'string;
import ballerina/log;
import ballerina/docker;
//Consumer 1
kafka:ConsumerConfiguration consConf = {
    bootstrapServers: "localhost:9092",
    groupId: "hod",

    topics: ["acceptedapplication","approvedproposal","fieapprovedproposal" ,"hdcapprovedproposal."],
    pollingIntervalInMillis: 1000, 
    //keyDeserializerType: kafka:DES_INT,
    //valueDeserializerType: kafka:DES_STRING,s
    autoCommit: false
};



listener kafka:Listener cons = new (consConf);
@docker:Config { 
    name: "hodCons",
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
        log:print("Value: " + messageContent);
    } else {
        log:printError("Invalid value type received");
    }
}