//
//  ListUserDataSource.swift
//  ProfileHarbor
//
//  Created by Lê Thành on 13/01/2024.
//

import UIKit

class ListUserDataSource: NSObject {
    
    var onDidSelectItem: ((Int) -> Void)?
    var onLoadMore: (() -> Void)?
    var onReloadList: (() -> Void)?
    
    private var items: [UserViewModel] = []
    var canLoadMore: Bool = true
    var lazyLoadManager: LazyLoadUserAvatarManager
    
    init(lazyLoadManager: LazyLoadUserAvatarManager) {
        self.lazyLoadManager = lazyLoadManager
    }
    
    func registerCell(_ tableView: UITableView) {
        let nib = UINib(nibName: UserViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: UserViewCell.identifier)
        let loadMoreNib = UINib(nibName: LoadMoreViewCell.nibName, bundle: nil)
        tableView.register(loadMoreNib, forCellReuseIdentifier: LoadMoreViewCell.identifier)
    }
    
    
    func appendItems(_ items: [UserViewModel]) {
        canLoadMore = items.count >= Constants.Pagination.maxPageSize
        self.items.append(contentsOf: items)
    }
    
    func updateItems(_ items: [UserViewModel]) {
        self.items = items
    }
    
    func stopLoadImages() {
        lazyLoadManager.reset()
    }
    
}

extension ListUserDataSource: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + (canLoadMore ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if canLoadMore && indexPath.row == items.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadMoreViewCell.identifier) as! LoadMoreViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: UserViewCell.identifier) as! UserViewCell
        let model = items[indexPath.row]
        cell.model = model
        
        lazyLoadManager.asyncDown(item: model, index: indexPath.row) { (data, index) in
            guard let data = data else { return }
            self.items[indexPath.row].imageData = data
            DispatchQueue.main.async {
                guard let __cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? UserViewCell,
                   let __model = __cell.model, __model.uid == model.uid else {
                       return
                }
                __cell.avatarImageView.image = UIImage(data: data)
            }
      }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onDidSelectItem?(items[indexPath.row].uid)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.lazyLoadManager.slowDownImageDownloadTaskfor(items[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        // Load more when user scrolls to the top
        if canLoadMore && contentHeight <= offsetY + height {
            self.onLoadMore?()
        }
    }

}
