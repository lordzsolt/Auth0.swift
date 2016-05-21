// UserProfile.swift
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

public struct UserProfile {

    public let id: String
    public let name: String
    public let nickname: String
    public let pictureURL: NSURL
    public let createdAt: NSDate

    public let email: String?
    public let emailVerified: Bool
    public let givenName: String?
    public let familyName: String?

    public let additionalAttributes: [String: AnyObject]

    public subscript(key: String) -> AnyObject? {
        return self.additionalAttributes[key]
    }

    public func value<Type>(key: String) -> Type? {
        return self[key] as? Type
    }

    public var userMetadata: [String: AnyObject] {
        return self["user_metadata"] as? [String: AnyObject] ?? [:]
    }

    public var appMetadata: [String: AnyObject] {
        return self["app_metadata"] as? [String: AnyObject] ?? [:]
    }

}

extension UserProfile: JSONObjectPayload {
    init?(json: [String: AnyObject]) {
        guard
            let id = json["user_id"] as? String,
            let name = json["name"] as? String,
            let nickname = json["nickname"] as? String,
            let picture = json["picture"] as? String, let pictureURL = NSURL(string: picture),
            let date = json["created_at"] as? String, let createdAt = fromSO8601(date)
            else { return nil }
        self.id = id
        self.name = name
        self.nickname = nickname
        self.pictureURL = pictureURL
        self.createdAt = createdAt
        self.email = json["email"] as? String
        self.emailVerified = json["email_verified"] as? Bool ?? false
        self.givenName = json["given_name"] as? String
        self.familyName = json["family_name"] as? String
        let keys = ["user_id", "name", "nickname", "picture", "created_at", "email", "email_verified", "given_name", "family_name"]
        var values: [String: AnyObject] = [:]
        json.forEach { key, value in
            guard !keys.contains(key) else { return }
            values[key] = value
        }
        self.additionalAttributes = values

    }
}

private func fromSO8601(string: String) -> NSDate? {
    let formatter = NSDateFormatter()
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
    return formatter.dateFromString(string)
}
