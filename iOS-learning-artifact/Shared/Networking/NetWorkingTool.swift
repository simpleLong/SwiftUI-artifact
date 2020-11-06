//
//  Data.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/22.
//

import SwiftUI

import SwiftUI
import ObjectMapper
typealias RequestBlock = ([String: Any]) -> ()

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = HTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = HTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = HTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = HTTPMethod(rawValue: "PUT")
    /// `TRACE` method.
    public static let trace = HTTPMethod(rawValue: "TRACE")
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
public protocol TargetType {
    
    /// The target's base `URL`.
    var baseURL: URL { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    /// Provides stub data for use in testing.
    var sampleData: Data { get }
    
    var parames: [String : String]? { get  }
    
    
    var headers: [String: String]? { get }
}


enum ApiManager {
    case login(account :String,password :String)
    case getQuestionSubmission(titleSlug:String)
    case getquestions
    case updateAlgorithmRecord(titleSlug: String)
    case getAlgorithmRecord(titleSlug: String)
}


extension ApiManager : TargetType {
    
    
    
    static let host = "http://101.32.23.218:8000"
    // static let host = "http://127.0.0.1:8000"
    var baseURL: URL {
        return URL.init(string: ApiManager.host)!
    }
    
    var path: String {
        switch self {
        case .login(account: _, password: _):
            return "/login/"
        case .getquestions:
            return "/getquestions/"
        case .getQuestionSubmission(titleSlug: _):
            return "/get_submissions/"
        case .updateAlgorithmRecord:
            return "/update_question_record/"
        case .getAlgorithmRecord:
            return "/get_question_record/"
            
        default:
            break
        }
    }
    
    var method: HTTPMethod {
        switch self {
        
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parames: [String : String]? {
        var commonParames:[String:String] = [:]
        if let account = UserDefaults.standard.value(forKey: "account") as? String {
            commonParames["account"] = account
        }
        switch self {
        case .login(account: let account, password: let password):
            commonParames["account"] = account
            commonParames["password"] = password
            
        case .getQuestionSubmission(titleSlug: let slug):
            commonParames["titleSlug"] = slug
        case .getAlgorithmRecord(titleSlug: let slug):
            commonParames["titleSlug"] = slug
            
        default:
            break
        }
        return commonParames
    }
    // MARK: -用来上传录音
    func upload(filePath: String ,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        let config = URLSessionConfiguration.default
        let url = self.baseURL.appendingPathComponent(self.path)
        var request = URLRequest(url: url)
        let session = URLSession(configuration: config)
        request.httpMethod = self.method.rawValue
        let urlpath = URL.init(fileURLWithPath: filePath)
        
        let data = try? Data(contentsOf: urlpath)
        let filename = filePath.components(separatedBy: "/").last!
        
        
        let boundary = "Boundary+\(arc4random())\(arc4random())"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var httpbody = Data.init()
        
        
        httpbody.append("\(boundary)\r\n".data(using: .utf8)!)
        httpbody.append("Content-Disposition: form-data; name=\"file\"; filename=\(filename)\r\n".data(using: .utf8)!)
        httpbody.append("Content-Type: audio/x-wav\r\n\r\n".data(using: .utf8)!)
        httpbody.append(data!)
        httpbody.append("\r\n".data(using: .utf8)!)
        httpbody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        if let parames = self.parames {
            for (key,value) in parames {
                httpbody.append("--\(boundary)\r\n".data(using: .utf8)!)
                httpbody.append("Content-Disposition: form-data; name=\(key)\r\n\r\n".data(using: .utf8)!)
                httpbody.append("\(value)\r\n".data(using: .utf8)!)
            }
        }
        
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: self.parames!, options: .prettyPrinted)
        let task = session.uploadTask(with: request, from: httpbody) { (data, response, error) in
            
        }
        //        激活请求任务
        task.resume()
        
        
        
    }
    // MARK: -下载录音
    func downloadRecord(slug:String ,deleagte :DownLoadDelegateClass) -> URLSessionDownloadTask {
        
        
        let sessionConfiguration = URLSessionConfiguration.default
        let url = self.baseURL.appendingPathComponent(self.path)
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        request.httpBody = try! JSONSerialization.data(withJSONObject: self.parames!, options: .prettyPrinted)
        let downloadSession = URLSession(configuration: sessionConfiguration, delegate: deleagte, delegateQueue: OperationQueue.main)
        
        
        let downloadTask = downloadSession.downloadTask(with: request)
        
        return downloadTask
        
        
    }
    
    
    func request(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        let config = URLSessionConfiguration.default
        let url = self.baseURL.appendingPathComponent(self.path)
        var request = URLRequest(url: url)
        let session = URLSession(configuration: config)
        request.httpMethod = self.method.rawValue
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: self.parames!, options: .prettyPrinted)
        let task = session.dataTask(with: request) {  (data,response,error) in
            
            
            
            completionHandler(data,response,error)
            
            
        }
        //        激活请求任务
        task.resume()
        
        
        
    }
    
    
}

class Api {
    
    func login( account :String ,password:String,  completion: @escaping (Bool) -> ()) {
        
        ApiManager.login(account: account, password: password).request { (data,respones,error)  in
            
            guard let data = data else {return}
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String :Any]
            guard let responsedata = dictionary?["data"] as? [String:Any] else {return}
            print("responsedata===",responsedata)
            if error != nil {
                completion(false)
            }else{
                if dictionary?["code"] as? String == "1"  {
                    completion(true)
                }else{
                    completion(false)
                }
            }
            
        }
        
    }
    
    
    
    func getquestions(completion: @escaping ([Question],[Section]) -> ()) {
        
        
        ApiManager.getquestions.request { (data,respones,error) in
            
            guard let data = data else {return}
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String :Any]
            guard let responsedata = dictionary?["data"] as? [String:Any] else {return}
            dealTheOriginData(data: responsedata) { (questions, sections) in
                DispatchQueue.main.async {
                    completion(questions,sections)
                }
            }
        }
        
    }
    
    
}

func dealTheOriginData(data: [String :Any],completion: @escaping ([Question],[Section]) -> ())  {
    
    guard let list = data["list"] as? [[String:Any]]  else {return}
    let questions = Mapper<Question>().mapArray(JSONArray: list)
    
    var dict : [String :Int] = [:]
    for qustion in questions {
        if let topicTags = qustion.topicTags {
            for topicTag in topicTags {
                dict[topicTag["name"]!] = dict[topicTag["name"]!] != nil ? dict[topicTag["name"]!]! + 1 : 1
            }
        }
        
    }
    var sections : [Section] = []
    
    let translateDict = ["Hash Table": "哈希表", "Bit Manipulation": "位运算", "Tree": "树", "Binary Search": "二分查找", "Math": "数学", "Heap": "堆", "Backtracking": "回溯算法", "String": "字符串", "Greedy": "贪心算法", "Graph": "图", "Sort": "排序", "Linked List": "链表", "Design": "设计", "Divide and Conquer": "分治算法", "Sliding Window": "滑动窗口", "Two Pointers": "双指针", "Array": "数组", "Dynamic Programming": "动态规划", "Depth-first Search": "深度优先", "Stack": "栈", "Breadth-first Search": "广度优先", "Union Find": "并查集","Topological Sort":"拓扑排序","Trie":"单词查找树"]
    
    for (index,item)  in dict.enumerated() {
        print("key===\(item.key),value===\(item.value)")
        
        let logoStr = item.key.replacingOccurrences(of: " ", with: "").lowercased()
        let imageName = "StarrySkybg\(index%9)"
        let section = Section(title: "标签分类为\(item.key)的算法题", subtitle: "\(item.value)道\(translateDict[item.key] ?? item.key )题", logo: logoStr, image: Image(imageName), color: LinearGradient(gradient: Gradient(colors: [gradients[index%14].color1, gradients[index%14].color2]), startPoint: .topLeading, endPoint: .bottomTrailing), shadowColor: gradients[index%14].color2,topicTag:item.key)
        sections.append(section)
        
        
    }
    print("dict====",dict)
    completion(questions,sections)
}
