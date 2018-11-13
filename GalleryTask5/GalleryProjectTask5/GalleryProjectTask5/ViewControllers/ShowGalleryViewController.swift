//
//  ViewController.swift
//  GalleryProjectTask5
//
//  Created by Maxim Panamarou on 10/12/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class ShowGalleryViewController: UIViewController, UIDropInteractionDelegate {
 
    private var selectedIndexPath: Int?
    
    var hallDescription: HallDescription? {
        didSet {
            navigationItem.title = hallDescription?.hallName
            if let imageCollectionViewCells = imagesCollectionView.visibleCells as? [ImageCollectionViewCell] {
                imageCollectionViewCells.forEach({$0.imageView.image = nil})
            }
            imagesCollectionView.reloadData()
        }
    }
    @IBOutlet weak var imagesCollectionView: UICollectionView! {
        didSet {
            imagesCollectionView.delegate = self
            imagesCollectionView.dataSource = self
            imagesCollectionView.dragDelegate = self
            imagesCollectionView.dropDelegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowImageViewControllerSegue" {
            if let controllet = segue.destination as? ShowImageViewController {
                guard let currentIndexUrl = selectedIndexPath else {return}
                controllet.imageUrl = hallDescription?.aspectRationForUrl[currentIndexUrl].url
            }
        }
    }
}

extension ShowGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let hall = hallDescription else {return 0}
        return hall.aspectRationForUrl.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell
        // to do to do to do to do to do!!!!!!!!!!!!!!!!
        if let hall = hallDescription {
           // if cell?.imageView.image == nil {
                cell?.activityIndicator.startAnimating()
                DispatchQueue.global(qos: .userInteractive).async {
                    do {
                        let imageData = try Data(contentsOf: hall.aspectRationForUrl[indexPath.row].url)
                        DispatchQueue.main.async {
                            cell?.activityIndicator.stopAnimating()
                            cell?.imageView.image = UIImage(data: imageData)
                        }
                    } catch (let error) {
                        self.present(AlertWithErrorAlertController.alertWithError(error), animated: true, completion: nil)
                        hall.aspectRationForUrl.remove(at: indexPath.row)
                        collectionView.deleteItems(at: [indexPath])
                    }
                }
           // }
        }
        return cell != nil ? cell! : UICollectionViewCell()
    }
}

extension ShowGalleryViewController: UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        performSegue(withIdentifier: "ShowImageViewControllerSegue", sender: nil)
    }
}

extension ShowGalleryViewController: UICollectionViewDropDelegate, UICollectionViewDragDelegate {
    // MARK: - UICollectionViewDragDelegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let cell = imagesCollectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            guard let image = cell.imageView.image else {return[]}
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItem.localObject = image
            return [dragItem]
        } else {
            return []
        }
    }
    // MARK: - UICollectionViewDropDelegate
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        guard hallDescription != nil else {return false}
        //session.canLoadObjects(ofClass: UIImage.self) &&  session.canLoadObjects(ofClass: NSURL.self)
        return true
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy,  intent: .insertAtDestinationIndexPath)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator
        ) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let _ = item.dragItem.localObject as? UIImage {
                    collectionView.performBatchUpdates({
                        let aspectRationForUrl = hallDescription?.aspectRationForUrl.remove(at: sourceIndexPath.item)
                        hallDescription?.aspectRationForUrl.insert(aspectRationForUrl!, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                        collectionView.collectionViewLayout.layoutAttributesForItem(at: sourceIndexPath)
                        collectionView.collectionViewLayout.layoutAttributesForItem(at: destinationIndexPath)
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else {
                let placeholderContext = coordinator.drop (
                    item.dragItem,
                    to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell")
                )
                var aspectRatio: CGFloat = 1
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (itemImage, error) in
                    if let image = itemImage as? UIImage {
                        aspectRatio = image.size.height / image.size.width
                    }
                }
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (url, error) in
                    DispatchQueue.main.async {
                        if let currentUrl = url as? URL {
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.hallDescription?.aspectRationForUrl.insert((currentUrl.imageURL, Float(aspectRatio)),
                                                                                at: insertionIndexPath.item)
                            })
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
           
        }
    }
  
}
extension ShowGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let aspectRatio  = hallDescription?.aspectRationForUrl[indexPath.row].aspectRatio
        guard  let fixWidth = hallDescription?.fixWidth, let ratio = aspectRatio else {
            return CGSize.zero
        }
        return CGSize(width: CGFloat(fixWidth), height: CGFloat(fixWidth * ratio))
    }
}
