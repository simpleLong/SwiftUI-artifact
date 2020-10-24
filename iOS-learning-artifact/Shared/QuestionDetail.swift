//
//  QuestionDetail.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/13.
//

import SwiftUI
import WebKit
struct WebLabel :UIViewRepresentable {
    @Binding var text:String
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {

        uiView.loadHTMLString(text, baseURL: nil)

    }
}
struct QuestionDetail: View {
    var titleSlug = ""
    @State var titleStr = ""
    @State var text = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text(titleStr)
                .font(.headline)
                .padding()
            WebLabel.init(text: $text)
                .padding()
                .frame(width: UIScreen.main.bounds.width, height: 400, alignment: .top)
            Spacer()
        }
        .navigationBarTitle(titleStr)
        .onAppear(perform: {
            getquestionDetail(titleSlug: titleSlug)
        })
    }
    
    func getquestionDetail(titleSlug :String) {
        
        //        加密，当传递的参数中含有中文时必须加密
        let newUrlString = "http://127.0.0.1:8000/getquestion_detail/"
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
        let params = ["title_slug":titleSlug,"question_status":"ac"]
        /**
         设置请求的Boby体
         */
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        //        创建请求任务
        let task = session.dataTask(with: request) { (data,response,error) in

//            let dictionary = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
//            print(dictionary!)
            if let data = data {
                let questionDeatilResponse = try? JSONDecoder().decode(QuestionDetailResponse.self, from: data)
                print(questionDeatilResponse?.data.translatedContent)

                if let htmlStr = questionDeatilResponse?.data.translatedContent {

                    titleStr = questionDeatilResponse?.data.translatedTitle ?? ""
                    if htmlStr.hasPrefix("</p>") {
                        let offsetIndex = htmlStr.index(htmlStr.startIndex, offsetBy: 4)
                        let offsetRange = offsetIndex..<htmlStr.endIndex
                        let extra = "<p> <font size=\(15)>"
                        text = extra  + htmlStr[offsetRange]
                    }else{
                        let offsetIndex = htmlStr.index(htmlStr.startIndex, offsetBy: 4)
                        let offsetRange = offsetIndex..<htmlStr.endIndex
                        let extra = "<p>  <font size=\(15)>"
                        text = extra  + htmlStr + "</p>"
                    }
                    

                    
                    
                }
                
            }

            
            
        }
        //        激活请求任务
        task.resume()
        
    }

}

struct QuestionDetail_Previews: PreviewProvider {
    static var previews: some View {
        QuestionDetail()
    }
}
