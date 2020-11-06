//
//  Submission.swift
//  iOS-learning-artifact
//
//  Created by longxd on 2020/11/6.
//
// 用来记录提交做题信息的类
import Foundation
import ObjectMapper

struct SubMission : Mappable ,Identifiable {
    var id = UUID()
    
    
    var runtime :String?
    var code :String?
    var memory :String?
    var statusDisplay :String?
    
    var timestamp :Double?
    var lang :String?
    
    /// 提交日期
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
