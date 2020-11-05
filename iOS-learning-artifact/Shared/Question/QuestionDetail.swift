//
//  QuestionDetail.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/10/13.
//

import SwiftUI
import WebKit
import ObjectMapper

var recordfilePath = ""

struct SubMission : Mappable ,Identifiable {
    var id = UUID()
    
    
    var runtime :String?
    var code :String?
    var memory :String?
    var statusDisplay :String?
    
    var timestamp :Double?
    var lang :String?
    var date :String {
        guard let timestamp = timestamp else {
            return ""
        }
        return timeStampToCurrennTime(timeStamp: timestamp)
    }
    
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        runtime <- map["runtime"]
        code <- map["code"]
        memory <- map["memory"]
        timestamp <- map["timestamp"]
        lang <- map["lang"]
        statusDisplay <- map["statusDisplay"]
    }
    
    
}
struct WebLabel :UIViewRepresentable {
    var text:String
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
        uiView.loadHTMLString(text, baseURL: nil)
        
    }
}
struct QuestionDetail: View {
    
    @State var contentText = ""
    @State var submissionModels : [SubMission] = []
    @State var showCode : Bool = false
    var questionDetail: Question
    @State var recordState : RecordStateEnum = .noStart
    @State private var animationAmount: CGFloat = 1
    @State var isUpdate :Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            
            WebLabel.init(text: dealTheContentFont(text: questionDetail.translatedContent))
                .frame(width: UIScreen.main.bounds.width, height: 400, alignment: .top)
                .padding()

            HStack {
                Spacer(minLength: 15)
                Text("提交记录")
                   // .offset(y:-30)
                    .padding()
                VStack(spacing:10) {
                    Record(recordState: $recordState, isUpdate: $isUpdate, slug: questionDetail.questionslug!)
                        

                    Text("长按记录解题思路")
                        .font(.system(size: 14))
                        .opacity(recordState == .start ? 0 : 1)
                        .animation( recordState == .start ? Animation.easeIn(duration:0.5) : nil)
                        
                }
                
            
                


                Spacer(minLength: 15)
                
            }
            ScrollView() {
                ForEach(submissionModels) { item in
                    VStack {
                        HStack(spacing:10) {

                            Text(item.date)
                                .font(.system(size: 14))
                            Text(item.statusDisplay!)
                                .font(.system(size: 14))
                            Text(item.runtime!)
                                .font(.system(size: 14))
                            Text(item.lang!)
                                .font(.system(size: 14))
                            Spacer()
                        }
                        .padding(10)
                        .onTapGesture{
                            self.showCode.toggle()
                        }
                        Divider()

                        .sheet(isPresented: self.$showCode, content: {
                            Text(item.code ?? "")
                                .padding()
                                .font(.body)
                    })
                    }

                    
                    //.edgesIgnoringSafeArea(.all)
                }
            }
            
        }
        .padding(15)
        .navigationBarTitle(questionDetail.translatedTitle!,displayMode: .inline)
        .font(.title)
        .alert(isPresented: $isUpdate, content: {
            Alert.init(title: Text("是否上传刚刚所录内容"), primaryButton: Alert.Button.cancel({
                self.isUpdate = false
            }), secondaryButton: Alert.Button.default(Text("OK"), action: {
                print("开始上传")
                print("recordfilePath==",recordfilePath)

                
                
                ApiManager.updateAlgorithmRecord(titleSlug: recordfilePath).upload(filePath: recordfilePath) { (data, response, error) in
                    print("data===",data)
                    print("response===",response)
                    print("error===",error)
                }
                self.isUpdate = false
                
            }))
        })
       
        .onAppear(perform: {
            getQuestionSubmission(titleSlug: questionDetail.questionslug)
        })
    }
    func dealTheContentFont(text: String?) -> String {
        if let htmlStr = text {

            if htmlStr.hasPrefix("</p>") {
                let offsetIndex = htmlStr.index(htmlStr.startIndex, offsetBy: 4)
                let offsetRange = offsetIndex..<htmlStr.endIndex
                let extra = "<p> <font size=\(14)>"
                return extra  + htmlStr[offsetRange]
            }else{
                
                let extra = "<p>  <font size=\(14)>"
                return extra  + htmlStr + "</p>"
            }

        }
        return ""
    }
    
    func getQuestionSubmission(titleSlug :String?) {
        
        
        
        ApiManager.getQuestionSubmission(titleSlug: titleSlug!).request { (data, response, error) in
 
            guard let data = data else {return}
            if  let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] {

                
                guard let submissions = dictionary["data"] as? [[String :Any]] else { return }
                print(submissions)
                submissionModels = Mapper<SubMission>().mapArray(JSONArray: submissions)
                print(submissionModels)
                
            }
            
            
        }
    
        
    }
    
}

func timeStampToCurrennTime(timeStamp: Double) -> String {
    //获取当前的时间戳
    //    let currentTime = Date().timeIntervalSinceNow
    //    //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
    //    let timeSta:TimeInterval = TimeInterval(timeStamp / 1000)
    //时间差
    let reduceTime : TimeInterval = timeStamp
    //时间差小于60秒
    if reduceTime < 60 {
        return "刚刚"
    }
    //时间差大于一分钟小于60分钟内
    let mins = Int(reduceTime / 60)
    if mins < 60 {
        return "\(mins)分钟前"
    }
    //时间差大于一小时小于24小时内
    let hours = Int(reduceTime / 3600)
    if hours < 24 {
        return "\(hours)小时前"
    }
    //时间差大于一天小于30天内
    let days = Int(reduceTime / 3600 / 24)
    if days < 30 {
        return "\(days)天前"
    }
    //不满足以上条件直接返回日期
    let date = NSDate(timeIntervalSince1970: timeStamp)
    let dfmatter = DateFormatter()
    //yyyy-MM-dd HH:mm:ss
    dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
    return dfmatter.string(from: date as Date)

}

struct QuestionDetail_Previews: PreviewProvider {
    static var previews: some View {
        QuestionDetail( questionDetail: questionItemData!)
    }
}
