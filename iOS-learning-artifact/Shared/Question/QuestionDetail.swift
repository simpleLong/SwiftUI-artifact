//
//  QuestionDetail.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/11/5.
//

import SwiftUI
import WebKit
import ObjectMapper
import Alamofire
import AVFoundation

let recordfilePath = URL.init(string: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)
/// 直接放在View里面会导致View的navigationBar无法正常显示,暂时还没有找到解决方法
/// 播放器的代理,当播放完毕后,会改变状态,更改播放按钮
var audioDelegate =  RecordDelegate()
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

struct QuestionDetail: View {
    
    @State var contentText = ""
    @State var submissionModels : [SubMission] = []
    @State var showCode : Bool = false
    var questionDetail: Question
    @State var recordState : RecordStateEnum = .noStart
    @State private var animationAmount: CGFloat = 1
    @State var isUpdate :Bool = false
    @EnvironmentObject var user: UserStore
    @State var isShowRecordPlayBtn = false
    @State var avplayerState: AudioPlayerState = .notStart
    

    var body: some View {
        ScrollView{
            
            VStack(alignment: .leading, spacing: 5){

                WebLabel.init(text: dealTheContentFont(text: questionDetail.translatedContent))
                    .frame(width: UIScreen.main.bounds.width-30, height: 400, alignment: .top)
                    .background(Color.red)
                
                Divider()
                
                HStack {
                    
                    if isShowRecordPlayBtn {
                        
                        Button(action: {
                            
                            self.avplayerState = self.avplayerState.changeState()
                            playRecord(titleSlug :questionDetail.questionslug!)
                            
                        }) {
                            VStack {// MARK: -播放按钮
                                if avplayerState != .isPlay {
                                    Image(systemName: "play.circle.fill").font(.system(size: 30, weight: .regular)).foregroundColor(.orange)
                                        .padding(1)
                                }else{
                                    Image(systemName: "pause.circle.fill").font(.system(size: 30, weight: .regular)).foregroundColor(.orange)
                                        .padding(1)
                                }
                                
                                Text("点击播放解题思路")
                                    .font(.subheadline)
                            }
                        }.buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                    
                    if !isShowRecordPlayBtn {
                        Spacer()
                    }
                    VStack(spacing:5) {
                        // MARK: -录音按钮
                        Record(recordState: $recordState, isUpdate: $isUpdate, slug: questionDetail.questionslug!)
                        Text("长按记录解题思路")
                            .font(.subheadline)
                            .opacity(recordState == .start ? 0 : 1)
                            .animation( recordState == .start ? Animation.easeIn(duration:0.5) : nil)
                        
                    }
                    .padding()
                    if !isShowRecordPlayBtn {
                        Spacer()
                    }
                }
                
                Divider()
                Text("提交记录")
                    .font(.subheadline)
                    .padding(.leading)
                    .opacity(user.isLogged == true ? 1 : 0)
                Divider()
                    .opacity(user.isLogged == true ? 1 : 0)
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
                    let filePath = recordfilePath!.absoluteString + "/" + questionDetail.questionslug! + ".wav"
                    self.isShowRecordPlayBtn = true
                    
                    ApiManager.updateAlgorithmRecord(titleSlug: questionDetail.questionslug!).upload(filePath: filePath) { (data, response, error) in
                        
                    }
                    self.isUpdate = false
                    
                }))
            })
            .onAppear(perform: {
                if user.isLogged {
                    getQuestionSubmission(titleSlug: questionDetail.questionslug)
                    
                }
                getTheRecordWithQuestion(titleSlug: questionDetail.questionslug!)
                
            })
        }
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
// MARK: -判断有没有记录这道题的算法思路录音
    func getTheRecordWithQuestion(titleSlug :String) -> Void {
        
        let recordName = "/" + titleSlug + ".wav"

        guard let documentsURL = recordfilePath?.appendingPathComponent(recordName) else { return }
        
        if let _ = try? AVAudioPlayer(contentsOf: documentsURL) {

            isShowRecordPlayBtn = true
        }else{
            let parameters: [String: String] = [
                "titleSlug":titleSlug
            ]
            let destination: DownloadRequest.Destination = { _, _ in
                
                print(documentsURL.absoluteString)
                return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            AF.download(ApiManager.getAlgorithmRecord(titleSlug: titleSlug).url.absoluteString, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: nil, interceptor: nil, requestModifier: nil, to: destination).downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseData { response in
                if let data = response.value {
                    print("data===",data)
                    isShowRecordPlayBtn = true
                    
                }
            }
        }
    }
    
     func playRecord(titleSlug :String) -> Void {
        
        let recordName = "/" + titleSlug + ".wav"
        
        guard let documentsURL = recordfilePath?.appendingPathComponent(recordName) else { return }
        
        do {
            try  audioPlayer =  AVAudioPlayer(contentsOf: documentsURL)

            audioDelegate.changeAudioPlayerBlock = { state in
                self.avplayerState = state

            }
            audioPlayer?.delegate = audioDelegate
            if audioPlayer?.isPlaying == true {
                audioPlayer?.pause()
            }else{
                audioPlayer?.play()
            }
   
        } catch  {
            print("初始化播放器失败")
        }
    }
}


enum AudioPlayerState {
    case notStart
    case isPlay
    case isPause
    case isFinish
    
    func changeState() -> AudioPlayerState {
        switch self {
        case .notStart,.isFinish,.isPause:
            return .isPlay
        case .isPlay:
            return .isPause
        }
    }
}

class RecordDelegate : NSObject ,AVAudioPlayerDelegate{
    
    var changeAudioPlayerBlock : ((AudioPlayerState) -> ())?
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

        if self.changeAudioPlayerBlock != nil {
            self.changeAudioPlayerBlock!(.isFinish)
        }
    }
}
struct QuestionDetail_Previews: PreviewProvider {
    static var previews: some View {
        QuestionDetail( questionDetail: questionItemData!)
    }
}


