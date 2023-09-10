//
//  Model.swift
//  kickboard
//
//  Created by Jooyeon Kang on 2023/09/05.
//

import UIKit

class StorageManager {
    
    static let userDefaults = UserDefaults.standard
    static let userKey = "User"
    static let kickboardKey = "Kickboard"
    static let userRideRecordKey = "UserRideRecord"
    
    //MARK: - Save Userdata
    static func saveUser(user: [User]) {
        do {
            let userData = try PropertyListEncoder().encode(user)
            userDefaults.set(userData, forKey: userKey)
        } catch {
            print("user 저장 실패")
        }
    }
    
    //MARK: - Fetch UserData
    static func fetchAllUser() -> [User]? {
        guard let userData = userDefaults.object(forKey: userKey) as? Data else {
            return []
        }
        
        do {
            let allUser = try PropertyListDecoder().decode([User].self, from: userData)
            return allUser
        } catch {
            print("user 불러오기 실패")
            return nil
        }
    }
    
    //MARK: - Fetch Userlogin Data
    static func fetchUserIsLogined() -> User? {
        guard let userData = userDefaults.object(forKey: userKey) as? Data else {
            return nil
        }
        
        do {
            let users = try PropertyListDecoder().decode([User].self, from: userData)
            let user = users.filter { $0.isLogined }.last
            return user
        } catch {
            print("user 불러오기 실패")
            return nil
        }
    }
    
    //MARK: - getKickboard
    
    static func getKickboard(byNumber number: Int) -> Kickboard? {
        return getAllKickboardList().last { $0.number == number }
    }
    
    //MARK: - updateKickboardStatus
    
    static func updateKickboardStatus(kickboard: Kickboard) {
        var kickboards = getAllKickboardList()
        if let index = kickboards.firstIndex(where: { $0.number == kickboard.number }) {
            kickboards[index].kickboardStatus.toggle()
            saveAllKickboards(kickboards: kickboards)
        }
    }
    
    //MARK: - saveAllKickboards
    
    static func saveAllKickboards(kickboards: [Kickboard]) {
        do {
            let kickboardData = try PropertyListEncoder().encode(kickboards)
            userDefaults.set(kickboardData, forKey: kickboardKey)
        } catch {
            print("Kickboards 저장 실패")
        }
    }
    
    
    //MARK: - Fetch Kickboard Data
    static func getAllKickboardList() -> [Kickboard] {
        guard let kickboardData = userDefaults.value(forKey: kickboardKey) as? Data,
              let kickboardList = try? PropertyListDecoder().decode([Kickboard].self, from: kickboardData) else { return [] }
        return kickboardList
    }
    
    static func getAllUserRideRecord() -> [UserRideRecord] {
        guard let rideData = userDefaults.value(forKey: userRideRecordKey) as? Data,
              let rideList = try? PropertyListDecoder().decode([UserRideRecord].self, from: rideData) else { return [] }
        
        return rideList
    }
    
    static func updateUserKickboardStatus() {
        guard var allUser = fetchAllUser() else { return }
        guard let userIsLogined = fetchUserIsLogined() else { return }
        
        for (index, i) in allUser.enumerated() {
            if i.userID == userIsLogined.userID {
                allUser[index].kickboardStatus.toggle()
            }
        }
        
        userDefaults.set(try? PropertyListEncoder().encode(allUser), forKey: userKey)
    }
    
    static func updateUserIsLogined(_ id: String) {
        guard var allUser = fetchAllUser() else { return }
        
        if let index = allUser.firstIndex(where: { $0.userID == id }) {
            allUser[index].isLogined.toggle()
        }
        
        userDefaults.set(try? PropertyListEncoder().encode(allUser), forKey: userKey)
    }
    
    static func updateKickboard(_ kickboard: Kickboard) {
        var allList = getAllKickboardList()
        
        for (index, i) in allList.enumerated() {
            if i.number == kickboard.number {
                allList[index] = kickboard
            }
        }
        
        userDefaults.set(try? PropertyListEncoder().encode(allList), forKey: kickboardKey)
    }
    
    static func insertUserRideRecord(_ record: UserRideRecord) {
        var allList = getAllUserRideRecord()
        allList.append(record)
        
        userDefaults.set(try? PropertyListEncoder().encode(allList), forKey: userRideRecordKey)
    }
    
//    MARK: - Fetch currently riding kickboard
    static func fetchUserRideRecord(for userID: String) -> UserRideRecord? {
        let records = getAllUserRideRecord()
        return records.last(where: { $0.userID == userID })
    }
}
    
 
struct User: Codable, Equatable {
    let userID: String
    let password: String
    var kickboardStatus: Bool
    var isLogined: Bool
}

struct Kickboard: Codable {
    let number: Int
    var kickboardStatus: Bool
    var locationX: Double // 경도
    var locationY: Double // 위도
    var userID: String?
}

struct UserRideRecord: Codable {
    let userID: String
    let kickboardNumber: Int
}

    //MARK: - Dummy Data
    var dummyData: [Kickboard] = [
        //서울 파이낸스 센터 : 서울 중구 세종대로 136 (태평로1가 84)
        Kickboard(number: 0,
                  kickboardStatus: false,
                  locationX: 126.9778,
                  locationY: 37.5684,
                  userID: nil),
        
        // 광화문 교보문고 : 서울 종로구 종로 1 (세종로 1)
        Kickboard(number: 1,
                  kickboardStatus: false,
                  locationX: 126.9778,
                  locationY: 37.5709,
                  userID: nil),
        
        // 세종문화회관 : 서울 종로구 세종대로 175 (세종로 81-3)
        Kickboard(number: 2,
                  kickboardStatus: false,
                  locationX: 126.9756,
                  locationY: 37.5725,
                  userID: nil),
        
        // 대한민국 역사박물관 : 서울 세종대로 198 (세종로 82-1)
        Kickboard(number: 3,
                  kickboardStatus: true,
                  locationX: 126.9781,
                  locationY: 37.5738,
                  userID: "user_test_id_3_1"),
        
        // 서대문독립공원방문자센터 : 서울 현저동 796-1
        Kickboard(number: 4,
                  kickboardStatus: false,
                  locationX: 126.9588,
                  locationY: 37.5720,
                  userID: nil),
        
        // 보신각 : 서울 종로구 종로 54 (관철동 45-5)
        Kickboard(number: 5,
                  kickboardStatus: true,
                  locationX: 126.9837,
                  locationY: 37.5698,
                  userID: "user_test_id_5_1"),
        
        // 미국 대사관 : 서울 종로구 세종대로 188 (세종로 82-14)
        Kickboard(number: 6,
                  kickboardStatus: false,
                  locationX: 126.9779,
                  locationY: 37.5731,
                  userID: nil),
        
        // 서울시청 : 서울 중구 세종대로 110 (태평로1가 31)
        Kickboard(number: 7,
                  kickboardStatus: true,
                  locationX: 126.9779,
                  locationY: 37.5662,
                  userID: "user_test_id_7_1"),
        
        // 외교부 : 서울 종로구 사직로 8길 60 (도렴동 95-1)
        Kickboard(number: 8,
                  kickboardStatus: false,
                  locationX: 126.9751,
                  locationY: 37.5736,
                  userID: nil),
        
        // 국립현대미술관 덕수궁 : 서울 중구 세종대로 99 (정동 5-1)
        Kickboard(number: 9,
                  kickboardStatus: false,
                  locationX: 126.9736,
                  locationY: 37.5658,
                  userID: nil)
    ]


