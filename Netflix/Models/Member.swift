//
//  Member.swift
//  Netflix
//
//  Created by Huy on 26/05/2024.
//

import Foundation
struct Member: Codable {
    let id: Int?
    let name: String?
    let image: String?
    
    static func saveMembers(members: [Member]){
       let membersData = try! JSONEncoder().encode(members)
       UserDefaults.standard.set(membersData, forKey: "members")
   }
   
    static func getMembers() -> [Member]?{
       let membersData = UserDefaults.standard.data(forKey: "members")
       if(membersData == nil){
           return []
       } else {
           let members = try! JSONDecoder().decode([Member].self, from: membersData!)
           return members
       }
   }
    
    static func saveCurrentMembers(member: Member){
       let memberData = try! JSONEncoder().encode(member)
       UserDefaults.standard.set(memberData, forKey: "member")
   }
   
    static func getCurrentMembers() -> Member?{
       let memberData = UserDefaults.standard.data(forKey: "member")
       if(memberData == nil){
           return nil
       } else {
           let member = try! JSONDecoder().decode(Member.self, from: memberData!)
           return member
       }
   }
   
}

