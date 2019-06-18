//
//  TaskFetcher.swift
//
//  Created by Otboss on 2019/4/28.
//

class TaskFetcher{
    
    //SENDS A REQUEST TO THE SERVER ASYNCHRONOUSLY
    func getUrl(url: String){
        directoryListing.currentPath += url;
        var request = URLRequest(url: URL(string: directoryListing.currentPath)!);
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type");
        let session = URLSession.shared;
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response);
            }
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder();
                    //CONVERTS THE JSON STRING RECEIVED FROM THE SERVER INTO AN OBJECT
                    let results = try jsonDecoder.decode(Task.self, from: data);
                    print("THE RESPONSE FROM THE QUERY IS: ");
                    print(results);
                } catch {
                    print(error)
                }
            }
        }.resume();

    }   
}

//STRUCT USED PARSE THE JSON STRING FROM THE SERVER
struct Task: Codable {
    var id<Int>
    var title<String>
    var description<String>
    var done<Bool>
}
