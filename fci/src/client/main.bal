
import ballerina/io;
import ballerina/http;
//import ballerina/lang.'int;


//interface
http:Client fieEndpoint = check new ("http://localhost:8080");
http:Client studentEndpoint = check new ("http://localhost:8082");
http:Client supervisorEndpoint = check new ("http://localhost:8083");
http:Client HODEndpoint = check new ("http://localhost:8084");
http:Client HDCEndpoint = check new ("http://localhost:8085");

public function main () {

        io:println("WELCOME TO     POSTGRAD");
        io:println("******************************");
        io:println("1.Student ");
        io:println("2.Supervisor  ");
        io:println("3.HOD  ");
        io:println("4.FIE  ");
        io:println("5.HDC   ");

       string choice = io:readln("Enter choice :");

       if (choice === "1"){
              io:println("WELCOME TO    POSTGRAD");
                    io:println("******************************");
                    io:println("1.Submit Application ");
                    io:println("2.Submit Proposal  ");

                  string option = io:readln("\nEnter option\n");

                    match option {
                        "1" => { 
                            
                             string name = io:readln("Enter name :");
                             string program  = io:readln("Enter  program :");
                             string Student_No = io:readln("Enter Student No :");
                             string contactNo  = io:readln("Enter  contactNo :");
                        
                          var  response = studentEndpoint->post("/graphql",{ query: " { studentProducerd(name:\""+name+"\",program:\""+program+"\",Student_No:\""+Student_No+"\",contactNo:\""+contactNo+"\") }" });
        
                                if (response is  http:Response) {
                                    var jsonResponse = response.getJsonPayload();

                                    if (jsonResponse is json) {
                                        
                                        io:println(jsonResponse);
                                    } else {
                                        io:println("Invalid payload received:", jsonResponse.message());
                                    }

                                }
                        
                        }
                        "2" => { 
                            string studentNo = io:readln("Student No :");
                            string background = io:readln("BackGround :");
                             string probStat  = io:readln("Enter  Problem Statement :");
                             string Obj = io:readln("Enter Objectives :");
                             string ScopeLimit  = io:readln("Enter  Scope Limitation :");
                        
                          var  response = studentEndpoint->post("/graphql",{ query: " { studentProposal(studentNo:\""+studentNo+"\",background:\""+background+"\",probStat:\""+probStat+"\",ScopeLimit:\""+ScopeLimit+"\") }" });
        
                                if (response is  http:Response) {
                                    var jsonResponse = response.getJsonPayload();

                                    if (jsonResponse is json) {
                                        
                                        io:println(jsonResponse);
                                    } else {
                                        io:println("Invalid payload received:", jsonResponse.message());
                                    }

                                }
                        



                        }
                    }


             //accessing the graphql service vID 
           

       }else if (choice=="2"){

        io:println("WELCOME TO    Supervisor");
                    io:println("******************************");
                    io:println("1.Accept Application ");
                    io:println("2.Accept Proposal  ");

                  string option = io:readln("\nEnter option\n");

                    match option {
                        "1" => { 
                       //accept supervisor
                             string Student_No = io:readln("Enter Student No :");
                             string supervisorID  = io:readln("Enter  Supervisor ID :");
                        
                             var  response = supervisorEndpoint->post("/graphql",{ query: " { supervisorProducerd(Applicant_ID:\""+Student_No+"\",supervisorID:\""+supervisorID+"\") }" });
        
                                if (response is  http:Response) {

                                    var jsonResponse = response.getJsonPayload();

                                    if (jsonResponse is json) {
                                        
                                        io:println(jsonResponse);

                                    } else {
                                        io:println("Invalid payload received:", jsonResponse.message());
                                    }

                                }
                        
                        }
                        "2" => { 
                        //   accept or deny proposal
                                 string Student_No = io:readln("Enter Student No :");
                                 string supervisorID  = io:readln("Enter  Supervisor ID :");
                                 string Response  = io:readln("Enter  Response :");
                        
                               var  response = supervisorEndpoint->post("/graphql",{ query: " { acceptProposal(Applicant_ID:\""+Student_No+"\",supervisorID:\""+supervisorID+"\",Response:\""+Response+"\") }" });
        
                                if (response is  http:Response) {

                                    var jsonResponse = response.getJsonPayload();

                                    if (jsonResponse is json) {
                                        
                                        io:println(jsonResponse);

                                    } else {
                                        io:println("Invalid payload received:", jsonResponse.message());
                                    }

                                }
                        }
                    }


       }else if (choice === "3"){
          
        io:println("WELCOME TO    HOD");
                    io:println("******************************");
                    io:println("1.Schedule Interview ");
                    io:println("2.Assign FIE  ");

                  string option = io:readln("\nEnter option\n");

                    match option {
                        "1" => { 
                       
                             string Student_No = io:readln("Enter Student No :");
                             string time  = io:readln("Enter  Time For Interview :");
                        
                             var  response = HODEndpoint->post("/graphql",{ query: " { interviewProducer(Applicant_ID:\""+Student_No+"\",time:\""+time+"\") }" });
        
                                if (response is  http:Response) {

                                    var jsonResponse = response.getJsonPayload();

                                    if (jsonResponse is json) {
                                        
                                        io:println(jsonResponse);

                                    } else {
                                        io:println("Invalid payload received:", jsonResponse.message());
                                    }

                                }
                        
                        }
                        "2" => {

                                string Student_No = io:readln("Enter Student No :");
                                string FIEID  = io:readln("Enter  FIEID :");
                            
                                var  response = HODEndpoint->post("/graphql",{ query: " { assignFIE(Applicant_ID:\""+Student_No+"\",FIEID:\""+FIEID+"\") }" });
            
                                    if (response is  http:Response) {

                                        var jsonResponse = response.getJsonPayload();

                                        if (jsonResponse is json) {
                                            
                                            io:println(jsonResponse);

                                        } else {
                                            io:println("Invalid payload received:", jsonResponse.message());
                                        }

                                    }


                         }
                    }


           }else if (choice === "4"){
          
        io:println("WELCOME TO    FIE");
                    io:println("******************************");
                    io:println("1.Review Proposal ");
                    

                  string option = io:readln("\nEnter option\n");

                    match option {
                        "1" => { 
                       
                             string Student_No = io:readln("Enter Student No :");
                             string approve  = io:readln("Sanction FIE approve :");
                        
                             var  response = fieEndpoint->post("/graphql",{ query: " { fieApprove(Student_No:\""+Student_No+"\",approve:\""+approve+"\") }" });
        
                                if (response is  http:Response) {

                                    var jsonResponse = response.getJsonPayload();

                                    if (jsonResponse is json) {
                                        
                                        io:println(jsonResponse);

                                    } else {
                                        io:println("Invalid payload received:", jsonResponse.message());
                                    }

                                }
                        
                        }
                        "2" => {

                                string Student_No = io:readln("Enter Student No :");
                                string FIEID  = io:readln("Enter  FIEID :");
                            
                                var  response = HODEndpoint->post("/graphql",{ query: " { assignFIE(Applicant_ID:\""+Student_No+"\",FIEID:\""+FIEID+"\") }" });
            
                                    if (response is  http:Response) {

                                        var jsonResponse = response.getJsonPayload();

                                        if (jsonResponse is json) {
                                            
                                            io:println(jsonResponse);

                                        } else {
                                            io:println("Invalid payload received:", jsonResponse.message());
                                        }

                                    }


                         }
                    }


           }else if (choice == "5"){
                io:println("WELCOME TO    HDC");
                    io:println("******************************");
                    io:println("1.Accept Proposal  ");

                  string option = io:readln("\nEnter option\n");

                    match option {
                        "1" => { 
                      //   accept or deny proposal
                                 string Student_No = io:readln("Enter Student No :");
                               
                                 string Response  = io:readln("Enter  Response :");
                        
                               var  response = HDCEndpoint->post("/graphql",{ query: " { acceptProposal(Applicant_ID:\""+Student_No+"\",Response:\""+Response+"\") }" });
        
                                if (response is  http:Response) {

                                    var jsonResponse = response.getJsonPayload();

                                    if (jsonResponse is json) {
                                        
                                        io:println(jsonResponse);

                                    } else {
                                        io:println("Invalid payload received:", jsonResponse.message());
                                    }

                                }
                        
                        }
                        "2" => { 
                      
                        }
                    }


           }
}


