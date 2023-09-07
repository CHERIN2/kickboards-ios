//
//  Model.swift
//  kickboard
//
//  Created by Jooyeon Kang on 2023/09/05.
//




import UIKit

class StorageManager {

private let userDefaults = UserDefaults.standard
    let userKey = "User"
    let kickboardKey = "Kickboard"
    let userRideRecordKey = "UserRideRecord"
    
    func saveUser(user: User) {
         do {
             let userData = try JSONEncoder().encode(user)
             userDefaults.set(userData, forKey: userKey)
         } catch {
             print("Failed to save user: \(error.localizedDescription)")
         }
     }
}

struct User: Codable {
    let userID: String
    let password: String
    let kickboardStatus: Bool
}

struct Kickboard: Codable {
    let number: Int
    let kickboardStatus: Bool
    let locationX: Double // 경도
    let locationY: Double // 위도
    let userID: String?
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
var dummyKey: String = "dummyData"
