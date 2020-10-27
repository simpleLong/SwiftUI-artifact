//
//  Data.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/22.
//

import SwiftUI

import SwiftUI
import ObjectMapper
struct Post: Codable, Identifiable {
    let id = UUID()
    var title: String
    var body: String
}

let host = "http://101.32.23.218:8000"

struct Question :Codable ,Identifiable ,Mappable {

    
    var id = UUID()
    
    var difficultyLabelColor : Color{
        guard let difficulty = difficulty else {
            return Color(#colorLiteral(red: 0, green: 0.5790003538, blue: 0.4385164976, alpha: 1))
        }
        let colorDict = ["Easy":Color(#colorLiteral(red: 0, green: 0.5790003538, blue: 0.4385164976, alpha: 1)),"Medium":Color(#colorLiteral(red: 0.8819206953, green: 0.5761888623, blue: 0.4387951195, alpha: 1)),"Hard":Color(#colorLiteral(red: 0.8828930855, green: 0.2852645516, blue: 0.2618650198, alpha: 1))]
        return colorDict[difficulty]!
        
    }
    
    var questionId :String?
    var questionTitle :String?
    var questionslug :String?
  //  var passRate :String?
    var difficulty: String?
    var questionFrontendId :String?
    var translatedTitle :String?
    

    var status :String?

    var topicTags:[[String:String]]?
    var translatedContent :String?
    var logo :String?
    var stats : [String:String]?
    
    var passRate: String{
        
        guard let stats = stats else {return ""}
        guard let acRate = stats["acRate"] else {return ""}
        
        return acRate
 
    }
    
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        questionId <- map["questionId"]
        questionFrontendId <- map["questionFrontendId"]
        questionTitle <- map["questionTitle"]
        translatedTitle <- map["translatedTitle"]
        questionslug <- map["questionTitleSlug"]
        difficulty <- map["difficulty"]
        translatedContent <- map["translatedContent"]
        topicTags <- map["topicTags"]
    }
    

    init() {
        
    }



}
class Api {
    func login( loginParams: [String:String] ,  completion: @escaping ([Question],[Section]) -> ()) {
        //let newUrlString = "http://101.32.23.218:8000/login/"
        let newUrlString = host + "/login/"

        let config = URLSessionConfiguration.default

        let url = URL(string: newUrlString)

        var request = URLRequest(url: url!)

        let session = URLSession(configuration: config)

        request.httpMethod = "POST"


        request.httpBody = try! JSONSerialization.data(withJSONObject: loginParams, options: .prettyPrinted)
        let task = session.dataTask(with: request) { [weak self] (data,response,error) in



            dealTheOriginData(data: data) { (questions, sections) in
                DispatchQueue.main.async {
                    completion(questions,sections)
                }
            }
            

            
            
        }
        //        激活请求任务
        task.resume()
    }
    
    func getPosts(completion: @escaping ([Post]) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            let posts = try! JSONDecoder().decode([Post].self, from: data)
            
            DispatchQueue.main.async {
                completion(posts)
            }
        }
        .resume()
    }
    
    func getquestions(completion: @escaping ([Question],[Section]) -> ()) {
        
        //let newUrlString = "http://101.32.23.218:8000/getquestions/"
        let newUrlString = host + "/getquestions/"

        let config = URLSessionConfiguration.default

        let url = URL(string: newUrlString)

        var request = URLRequest(url: url!)

        let session = URLSession(configuration: config)

        request.httpMethod = "POST"

//        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)

        let task = session.dataTask(with: request) { [weak self] (data,response,error) in
            



            dealTheOriginData(data: data) { (questions, sections) in
                DispatchQueue.main.async {
                    completion(questions,sections)
                }
            }
            

            
            
        }
        //        激活请求任务
        task.resume()
        
    }
    
    
}

func dealTheOriginData(data: Data?,completion: @escaping ([Question],[Section]) -> ())  {
    guard let data = data else { return }
    let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String :Any]
    guard let questionData = dictionary?["data"] as? [String:Any] else {return}
    guard let list = questionData["list"] as? [[String:Any]]  else {return}
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
