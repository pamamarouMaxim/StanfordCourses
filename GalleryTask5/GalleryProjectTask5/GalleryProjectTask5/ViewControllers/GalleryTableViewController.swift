//
//  GalleryTableViewController.swift
//  GalleryProjectTask5
//
//  Created by Maxim Panamarou on 10/12/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class GalleryTableViewController: UITableViewController {
    var gallery = GalleryDescriptionModel()
    private var doubleTap : UITapGestureRecognizer {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(renameCell(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        return doubleTap
    }
    @IBAction func addHellBarButtonItem(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add new hall \n with name", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter hall name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [weak self] alert -> Void in
            guard let textFieldText = alertController.textFields?.first?.text else {return}
            self?.gallery.shownHalls.insert(HallDescription(hallName: textFieldText), at: 0)
            self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .left)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @objc func renameCell(_ sender: UITapGestureRecognizer) {
        if let cell = sender.view as? GalleryTableViewCell {
            cell.hallNameText = { [unowned self, cell] newHallName in
                let cellIndexPath = self.tableView.indexPath(for: cell)
                if cellIndexPath?.section == 0 {
                    self.gallery.shownHalls[(cellIndexPath?.row)!].hallName = newHallName!
                } else {
                    self.gallery.recentlyDeletedHalls[(cellIndexPath?.row)!].hallName = newHallName!
                }
            }
            cell.galleryNameTextField.isEnabled = true
            cell.galleryNameTextField.becomeFirstResponder()
            
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return gallery.galleryHalls.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gallery.galleryHalls[section].count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if let textField = cell.contentView.subviews.first as? UITextField {
            textField.text = gallery.galleryHalls[indexPath.section][indexPath.row].hallName
            cell.addGestureRecognizer(doubleTap)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var destinationInfo : (actionTittle: String, toSection: Int, test: [HallDescription])
        destinationInfo = indexPath.section == 0 ?  ("delete", 1, gallery.shownHalls) : ("undelete", 0, gallery.recentlyDeletedHalls)
        let closeAction = UIContextualAction(style: .normal,
                                             title:  destinationInfo.actionTittle,
                                             handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                                                var hall = self.gallery.galleryHalls[indexPath.section]
                                                let remoteHall = hall.remove(at: indexPath.row)
                                                var dest = self.gallery.galleryHalls[destinationInfo.toSection]
                                                dest.append(remoteHall)
                                                if indexPath.section == 0 {
                                                    self.gallery.shownHalls = hall
                                                    self.gallery.recentlyDeletedHalls = dest
                                                } else {
                                                    self.gallery.shownHalls = dest
                                                    self.gallery.recentlyDeletedHalls = hall
                                                }
                                                self.tableView.moveRow(at: indexPath,
                                                                       to: IndexPath(row: 0, section: destinationInfo.toSection))
                                                success(true)
        })
        closeAction.backgroundColor = indexPath.section == 0 ? UIColor.orange : UIColor.green
        return UISwipeActionsConfiguration(actions: [closeAction])
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let hall = gallery.shownHalls[indexPath.row]
            guard let navigationController = splitViewController?.viewControllers.last as? UINavigationController else {return}
            guard let showGalleryViewController = navigationController.viewControllers.first as? ShowGalleryViewController else {return}
            if showGalleryViewController.hallDescription !== hall {
                showGalleryViewController.hallDescription = hall
            }
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Open halls" : "Closed halls"
    }
     // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == gallery.galleryHalls.count - 1 {
            if editingStyle == .delete {
                gallery.recentlyDeletedHalls.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .top)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
}
