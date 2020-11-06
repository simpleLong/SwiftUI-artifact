//
//  Record.swift
//  LeetCode
//
//  Created by longxd on 2020/10/14.
//

import SwiftUI
import Foundation
import AVFoundation


struct LongPressButton : UIViewRepresentable{
    @Binding var recordState : RecordStateEnum
    @Binding var isUpdate : Bool
    var titleSlug :String!

    
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIView(context: Context) -> UIImageView{
        
        let image = UIImage(systemName: "mic", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
        let imageView = UIImageView.init(image: image)
        let gesture = UILongPressGestureRecognizer.init(target: context.coordinator, action: #selector(context.coordinator.startRecord(gesture:)))
        

        
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        gesture.delegate = context.coordinator
        return imageView
        
        
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    class Coordinator: NSObject ,UIGestureRecognizerDelegate {
        let parent: LongPressButton
        let recordManage = RecordManager()
        
        
        
        @objc func startRecord(gesture:UILongPressGestureRecognizer) -> Void {
            if gesture.state == .began {
                print("开始了")
                let recordName = "/" + parent.titleSlug + ".wav"
                
                recordManage.file_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + recordName
                parent.recordState = RecordStateEnum.start
                recordManage.beginRecord()
            }else if gesture.state == .cancelled{
                print("cancelled")
            }else if gesture.state == .changed{
                print("change")
            }else{
                print("结束了")
                parent.recordState = RecordStateEnum.end
                
                recordManage.stopRecord()
                parent.isUpdate = true
                
                recordfilePath = recordManage.file_path!
                print(recordfilePath)
                
            }
        }
        
        init(_ parent: LongPressButton) {
            self.parent = parent
        }
    }
}

class RecordManager {
    

    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?

    var file_path : String?//= NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    
    
    //开始录音
    func beginRecord() {
        let session = AVAudioSession.sharedInstance()
        //设置session类型
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
        } catch let err{
            print("设置类型失败:\(err.localizedDescription)")
        }
        //设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化动作失败:\(err.localizedDescription)")
        }

        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),//采样率
                                            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
                                            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
                                            AVNumberOfChannelsKey: NSNumber(value: 1),//通道数
                                            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
        ];
        //开始录音
        do {
            let url = URL(fileURLWithPath: file_path!)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            print("开始录音")
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
    }
    
    
    //结束录音
    func stopRecord() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                print("正在录音，马上结束它，文件保存到了：\(file_path!)")
            }else {
                print("没有录音，但是依然结束它")
            }
            recorder.stop()
            self.recorder = nil
        }else {
            print("没有初始化")
        }
    }
    
    
    //播放
    func play() {
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: file_path!))
            print("歌曲长度：\(player!.duration)")
            player!.play()
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
    }
    
}
enum RecordStateEnum {
    case noStart
    case start
    case end
}

struct Record: View {
    
    @Binding var recordState : RecordStateEnum
    @Binding var isUpdate :Bool
    var slug :String
    
    var body: some View {
        
        
        ZStack {
            LongPressButton(recordState: $recordState, isUpdate: $isUpdate ,titleSlug: slug)
                .frame(width: 25, height: 25, alignment: .center)
                .background(
                    Circle()
                        
                        .strokeBorder(Color.red)
                        .frame(width: recordState == RecordStateEnum.start ? 75 : 40, height: recordState == RecordStateEnum.start ? 75 : 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .opacity(recordState == RecordStateEnum.start ? 1 : 0)
                        
                        .animation(recordState == .start ? Animation.easeIn(duration: 1).repeatForever() : nil))
            
            
        }
        
    }
}

struct Record_Previews: PreviewProvider {
    static var previews: some View {
        Record(recordState: .constant(.noStart), isUpdate: .constant(false), slug: "")
    }
}
