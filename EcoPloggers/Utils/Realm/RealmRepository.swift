//
//  RealmRepository.swift
//  EcoPloggers
//
//  Created by Jisoo Ham on 9/2/24.
//

import Foundation

import RealmSwift

final class RealmRepository {
    static let shared = RealmRepository()
    private let realm = try! Realm()
    
    private init () {
        print(realm.configuration.fileURL)
    }
    
    func readPosts() -> [SeenPosts] {
        let posts = realm.objects(SeenPosts.self)
        return Array(posts)
    }
    
    func addPosts(post: SeenPosts) {
        do {
            try realm.write {
                realm.add(post)
            }
        } catch {
            print(RealmError.create.errorDescription ?? "")
        }
    }
}
