import Foundation
import Alamofire

typealias JSONDictionary = [String: Any]
typealias JSONArray = [JSONDictionary]

class APIClient {
  static let shared = APIClient()

  private let clientId = "9552a4bf126c4c18af03b3d104e8a50b"
  private let redirectUri = "https://github.com/argyrus/PhotoFeed"

  var parameters: JSONDictionary {
    guard let accessToken = accessToken else {
      return [:]
    }

    return [
      "access_token": accessToken,
      "scope": "follower_list"
    ]
  }

  var accessToken: String? {
    get {
      return UserDefaults.standard.string(forKey: "accessToken")
    }
    set {
      if let newValue = newValue {
        UserDefaults.standard.set(newValue, forKey: "accessToken")
      } else {
        UserDefaults.standard.removeObject(forKey: "accessToken")
      }

      UserDefaults.standard.synchronize()
    }
  }

  var loginUrl: URL {
    return URL(string: "https://api.instagram.com/oauth/authorize/?client_id=\(clientId)&redirect_uri=\(redirectUri)&response_type=token")!
  }

  func loadMedia(userId: String = "self", completion: @escaping ([Media]) -> Void) {
    
    request("https://api.instagram.com/v1/users/\(userId)/media/recent",
            parameters: parameters)
    .responseData(completionHandler: { (response) in
        print(response)

      if let data = response.result.value {
        do {
          let holder = try JSONDecoder().decode(ListHolder<Media>.self, from: data)
          DispatchQueue.main.async {
            completion(holder.list)
          }
        } catch {
          print(error)
        }
      }
    })
  }

  func loadUsersWhoLike(mediaId: String, completion: @escaping ([User]) -> Void) {
    request("https://api.instagram.com/v1/media/\(mediaId)/likes",
            parameters: parameters)
    .responseData(completionHandler: { (response) in
        print(response)
 if let data = response.result.value {
        do {
          let holder = try JSONDecoder().decode(ListHolder<User>.self, from: data)
          DispatchQueue.main.async {
            completion(holder.list)
          }
        } catch {
          print(error)
        }
      }
    })
  }

  func loadComments(mediaId: String, completion: @escaping ([Comment]) -> Void) {
    request("https://api.instagram.com/v1/media/\(mediaId)/comments",
      parameters: parameters)
    .responseData(completionHandler: { (response) in
        print(response)
      if let data = response.result.value {
        do {
          let holder = try JSONDecoder().decode(ListHolder<Comment>.self, from: data)
          DispatchQueue.main.async {
            completion(holder.list)
          }
        } catch {
          print(error)
        }
      }
    })
  }

  func loadInfo(userId: String, completion: @escaping (User) -> Void) {
    request("https://api.instagram.com/v1/users/\(userId)",
      parameters: parameters)
    .responseData(completionHandler: { (response) in
      if let data = response.result.value {
        do {
          let holder = try JSONDecoder().decode(OneHolder<User>.self, from: data)
            print(holder)

          DispatchQueue.main.async {
            completion(holder.one)
          }
        } catch {
          print(error)
        }
      }
    })
  }

  func loadFollowing(userId: String, completion: @escaping ([User]) -> Void) {
    request("https://api.instagram.com/v1/users/\(userId)/follows",
      parameters: parameters)
    .responseData(completionHandler: { (response) in
      if let data = response.result.value {
        do {
          let holder = try JSONDecoder().decode(ListHolder<User>.self, from: data)
            print(holder)
          DispatchQueue.main.async {
            completion(holder.list)
          }
        } catch {
          print(error)
        }
      }
    })
  }

  func loadFollowers(userId: String, completion: @escaping ([User]) -> Void) {
    request("https://api.instagram.com/v1/users/\(userId)/followed-by",
      parameters: parameters)
    .responseData(completionHandler: { (response) in
      if let data = response.result.value {
        do {
          let holder = try JSONDecoder().decode(ListHolder<User>.self, from: data)
            print(holder)
          DispatchQueue.main.async {
            completion(holder.list)
          }
        } catch {
          print(error)
        }
      }
    })
  }
}
