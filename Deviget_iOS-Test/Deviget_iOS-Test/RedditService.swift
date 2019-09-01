//
//  RedditService.swift
//  Deviget_iOS-Test
//
//  Created by Augusto Collerone on 30/08/2019.
//  Copyright © 2019 Augusto Collerone. All rights reserved.
//

import Foundation

struct ServiceResponse: Decodable {
    let kind: String
    let data: ServiceResponseData
}

struct ServiceResponseData: Decodable {
    let children: [Entry]
}

struct Entry: Decodable {
    let kind: String
    let data: EntryData
}

struct EntryData: Decodable {
    let title: String
    let authorName: String
    let commentsAmount: Int
    let timeCreated: Int64
    let thumbnailHeight: Int?
    let thumbnailURL: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case authorName = "author"
        case commentsAmount = "num_comments"
        case timeCreated = "created_utc"
        case thumbnailHeight = "thumbnail_height"
        case thumbnailURL = "thumbnail"
        case imageURL = "url"
    }
}

class RedditService {
    static func requestData(success: @escaping (([EntryData]) -> Void), failure: @escaping ((Error) -> Void)) {
        let session = URLSession.shared
        let entriesAmount = 50
        
        guard let url = URL(string: "http://reddit.com/top.json?limit=\(entriesAmount)") else {
            return
        }
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                failure(error)
            } else {
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let entries = try decoder.decode(ServiceResponse.self, from: data)
                    var entriesData: [EntryData] = []
                    for child in entries.data.children {
                        entriesData.append(child.data)
                    }
                    DispatchQueue.main.async {
                        success(entriesData)
                    }
                } catch let err {
                    DispatchQueue.main.async {
                        failure(err)
                    }
                }
            }
        })
        
        task.resume()
    }
    
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
