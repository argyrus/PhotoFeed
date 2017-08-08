import UIKit

class FollowingController: TableController<User, UserCell> {
  var userId: String?

  override func loadData() {
    guard let mediaId = mediaId else {
      return
    }

    APIClient.shared.loadUsersWhoLike(mediaId: mediaId) { [weak self] (users) in
      self?.items = users
      self?.tableView.reloadData()
    }
  }

  override func configure(cell: UserCell, model: User) {
    cell.configure(with: model)
  }
}

