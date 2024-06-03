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
    
    static func saveMembers(members: [Member]) {
        do {
            let membersData = try JSONEncoder().encode(members)
            UserDefaults.standard.set(membersData, forKey: "members")
        } catch {
            print("Failed to save members: \(error.localizedDescription)")
        }
    }

    static func getMembers() -> [Member]? {
        guard let membersData = UserDefaults.standard.data(forKey: "members") else {
            return []
        }
        do {
            let members = try JSONDecoder().decode([Member].self, from: membersData)
            return members
        } catch {
            print("Failed to decode members: \(error.localizedDescription)")
            return nil
        }
    }

    static func saveCurrentMembers(member: Member) {
        do {
            let memberData = try JSONEncoder().encode(member)
            UserDefaults.standard.set(memberData, forKey: "member")
        } catch {
            print("Failed to save current member: \(error.localizedDescription)")
        }
    }

    static func getCurrentMembers() -> Member? {
        guard let memberData = UserDefaults.standard.data(forKey: "member") else {
            return nil
        }
        do {
            let member = try JSONDecoder().decode(Member.self, from: memberData)
            return member
        } catch {
            print("Failed to decode current member: \(error.localizedDescription)")
            return nil
        }
    }
}
