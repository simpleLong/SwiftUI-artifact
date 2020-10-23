//
//  RootView.swift
//  iOS-learning-artifact
//
//  Created by 龙晓东 on 2020/9/16.
//

import SwiftUI



struct RootView: View {
//    var questionItems : StatStatusPair = Bundle.main.decode(QuestionResponse.self, from: "questions.json").data.statStatusPairs
    var body: some View {
        QuestionListView()
    }
}


func loadQuestionData() {
    let questions = Bundle.main.decode(QuestionResponse.self, from: "questions.json")
    print("questions====",questions.data.questions.count)


//    let jsonData = """
//            {
//                "questionId": 1000147,
//                "questiontitle": "黑盒光线反射",
//                "questionslug": "IQvJ9i",
//                "passRate": "20.1%",
//                "difficulty": "Hard",
//                "frontendQuestionId": "LCP 27",
//                "columnArticles": 11,
//                "status": null,
//                "paidOnly": false
//            }
//            """.data(using: .utf8)!
//    do {
//        let city = try JSONDecoder().decode(Question.self, from: jsonData)
//        print("city:", city)
//    } catch {
//        print(error.localizedDescription)
//    }

    
}

func getquestions() {
    
    //        加密，当传递的参数中含有中文时必须加密
            let newUrlString = "http://127.0.0.1:8000/getquestions/"
            //创建请求配置
            let config = URLSessionConfiguration.default
    //        创建请求URL
    let url = URL(string: newUrlString)
    //        创建请求实例
            var request = URLRequest(url: url!)
            
    //        进行请求头的设置
    //        request.setValue(Any?, forKey: String)
            
    //        创建请求Session
            let session = URLSession(configuration: config)
    /**
     设置请求的类型
     */
    request.httpMethod = "POST"
    /**
     请求参数
     */
    let params = ["account":"18588409461","password":"@Lxd199011"] 
    /**
     设置请求的Boby体
     */
    request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
    //        创建请求任务
            let task = session.dataTask(with: request) { (data,response,error) in
    //            print(String(data: data! , encoding: .utf8) as Any)
    //            将json数据解析成字典
                let dictionary = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print(dictionary!)
                
            }
    //        激活请求任务
            task.resume()

}
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
