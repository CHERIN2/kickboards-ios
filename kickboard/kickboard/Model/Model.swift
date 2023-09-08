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
    static func saveUser(user: User) {
        do {
            let userData = try PropertyListEncoder().encode(user)
            userDefaults.set(userData, forKey: userKey)
        } catch {
            print("user 저장 실패")
        }
    }
    
    //MARK: - Fetch UserData
    static func fetchUser() -> User? {
        guard let userData = userDefaults.object(forKey: userKey) as? Data else {
            return nil
        }
        
        do {
            let user = try PropertyListDecoder().decode(User.self, from: userData)
            return user
        } catch {
            print("user 불러오기 실패")
            return nil
        }
    }
    
    //MARK: - Save Kick
    
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

    static func updateUserKickboardStatus(isRiding: Bool) {
        var newUser = fetchUser()
        newUser?.kickboardStatus = isRiding
        
        userDefaults.set(try? PropertyListEncoder().encode(newUser), forKey: userKey)
    }

    static func updateKickboard(_ kickboard: Kickboard) {
        var allList = getAllKickboardList()
        var list = allList.filter { $0.number == kickboard.number }
        list[0] = kickboard
        allList.append(list[0])
        
        userDefaults.set(try? PropertyListEncoder().encode(allList), forKey: kickboardKey)
    }
    
    static func insertUserRideRecord(_ record: UserRideRecord) {
        var allList = getAllUserRideRecord()
        allList.append(record)
        
        userDefaults.set(try? PropertyListEncoder().encode(allList), forKey: userRideRecordKey)
    }
}
    
struct User: Codable, Equatable {
    let userID: String
    let password: String
    var kickboardStatus: Bool
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

var dummyData: [Kickboard] = [
    Kickboard(number: 0,
              kickboardStatus: false,
              locationX:  126.9552,
              locationY: 37.5656,
              userID: nil),
    Kickboard(number: 1,
              kickboardStatus: false,
              locationX: 126.9778,
              locationY: 37.5709,
              userID: nil),
    Kickboard(number: 2,
              kickboardStatus: false,
              locationX: 126.9756,
              locationY: 37.5756,
              userID: nil),
    Kickboard(number: 3,
              kickboardStatus: true,
              locationX: 126.9781,
              locationY: 37.5738,
              userID: "user_test_id_3_1"),
    Kickboard(number: 4,
              kickboardStatus: false,
              locationX: 126.9780,
              locationY: 37.5692,
              userID: nil),
    Kickboard(number: 5,
              kickboardStatus: true,
              locationX: 126.9837,
              locationY: 37.5698,
              userID: "user_test_id_5_1"),
    Kickboard(number: 6,
              kickboardStatus: false,
              locationX: 126.9779,
              locationY: 37.5731,
              userID: nil),
    Kickboard(number: 7,
              kickboardStatus: true,
              locationX: 126.9752,
              locationY: 37.5749,
              userID: "user_test_id_7_1"),
    Kickboard(number: 8,
              kickboardStatus: false,
              locationX: 126.9751,
              locationY: 37.5736,
              userID: nil),
    Kickboard(number: 9,
              kickboardStatus: true,
              locationX: 126.9790,
              locationY: 37.5816,
              userID: "user_test_id_9_1"),
    Kickboard(number: 10,
              kickboardStatus: false,
              locationX: 126.5867,
              locationY: 37.9747,
              userID: nil)
]
