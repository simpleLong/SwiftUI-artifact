//
//  QuestionDetail.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/11/5.
//

import SwiftUI
import WebKit
import ObjectMapper

var recordfilePath = ""

// MARK: -将WKWebVIEW 转化成SwiftUI 能用的类型
struct WebLabel :UIViewRepresentable {
    var text:String
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
        uiView.loadHTMLString(text, baseURL: nil)
        
    }
}

class Down: ObservableObject {
    @Published  var downloadTask : URLSessionDownloadTask?
    @Published  var downloaddelegate : DownLoadDelegateClass?
}
struct QuestionDetail: View {
    
    @State var contentText = ""
    @State var submissionModels : [SubMission] = []
    @State var showCode : Bool = false
    var questionDetail: Question
    @State var recordState : RecordStateEnum = .noStart
    @State private var animationAmount: CGFloat = 1
    @State var isUpdate :Bool = false
    @ObservedObject var down : Down
    @Binding var showSelf: Bool
    
    
    
    var body: some View {
        ScrollView{
            
            VStack(alignment: .leading, spacing: 10){
                
                Button(action: {
                    self.showSelf = false
                }) {
                    Image("backIcon")
                }
                .frame(height: 40)
                WebLabel.init(text: dealTheContentFont(text: questionDetail.translatedContent))
                    .frame(width: UIScreen.main.bounds.width-30, height: 400, alignment: .top)
                    .background(Color.red)
                
                Divider()
                
                HStack {
                    
                    Text("提交记录")
                        .font(.subheadline)
                        .padding()
                    
                    VStack {
                        Image(systemName: "play.circle.fill").font(.system(size: 30, weight: .regular)).foregroundColor(.orange)
                            .padding(2)
                        
                        Text("点击播放解题思路")
                            .font(.subheadline)
                    }
                    .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                        
                        
                    })
                    
                    VStack(spacing:10) {
                        Record(recordState: $recordState, isUpdate: $isUpdate, slug: questionDetail.questionslug!)
                        
                        Text("长按记录解题思路")
                            .font(.subheadline)
                            .opacity(recordState == .start ? 0 : 1)
                            .animation( recordState == .start ? Animation.easeIn(duration:0.5) : nil)
                        
                    }
                    .padding()
                    
                }
                
                Divider()
                
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
                                    ScrollView {
                                        Text(item.code ?? "")
                                            .padding()
                                            .font(.body)
                                    }
                                })
                        }
                        
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
                        
                    }
                    self.isUpdate = false
                    
                }))
            })
            .onAppear(perform: {
                getQuestionSubmission(titleSlug: questionDetail.questionslug)
            })
        }.navigationBarHidden(true)
        
    }
    // MARK: -设置题目的字体大小
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
    // MARK: - 获取关于本题的提交记录
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


struct QuestionDetail_Previews: PreviewProvider {
    static var previews: some View {
        QuestionDetail( questionDetail: questionItemData!, down: Down(), showSelf: .constant(true))
    }
}

class DownLoadDelegateClass:NSObject ,URLSessionDataDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("")
    }
    // 接收到服务器响应的时候调用该方法 completionHandler .allow 继续接收数据
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("开始响应...............")
        completionHandler(.allow)
    }
    //接收到数据 可能调用多次
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("接收到数据...............")
        
    }
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {

    }
    
}
