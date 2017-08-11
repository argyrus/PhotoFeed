/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class FeedController: TableController<Media, MediaCell>, MediaCellDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()

    // title
    let label = UILabel()
    label.text = "Photo Feed"
    label.textColor = .black
    label.font = UIFont(name: "Noteworthy-Bold", size: 25)
    navigationItem.titleView = label

    // Navigation items
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "send"),
                                                        style: .done, target: nil, action: nil)

    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera"),
                                                        style: .done, target: nil, action: nil)
  }

  override func loadData() {
    APIClient.shared.loadMedia { [weak self] mediaList in
      self?.items = mediaList
      self?.tableView.reloadData()
    }
  }

  override func configure(cell: MediaCell, model: Media) {
    cell.configure(with: model)
    cell.delegate = self
  }

  // MARK: - MediaCellDelegate

  func mediaCell(_ cell: MediaCell, didViewLikes mediaId: String) {
    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LikesController") as! LikesController
    controller.mediaId = mediaId
    navigationController?.pushViewController(controller, animated: true)
  }

  func mediaCell(_ cell: MediaCell, didViewComments mediaId: String) {
    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsController") as! CommentsController
    controller.mediaId = mediaId
    navigationController?.pushViewController(controller, animated: true)
  }

  func mediaCell(_ cell: MediaCell, didSelectUserName userId: String) {
    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserController") as! UserController
    controller.userId = userId
    navigationController?.pushViewController(controller, animated: true)
  }
}
