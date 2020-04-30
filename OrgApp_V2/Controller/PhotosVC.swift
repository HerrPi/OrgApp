import UIKit
import RealmSwift
import Photos

class PhotosVC: UIViewController {
	@IBOutlet weak var photosCollectionView: UICollectionView!
	@IBOutlet weak var projectTitle: UILabel!

	var tabBarVC: ProjectTabBarVC!
	var thisProject: Project!
	var photos: List<Photo>!
	var photoAssets: PHFetchResult<PHAsset>!

	var photoSize = CGSize(width: 0, height: 0)
	var imageManager = PHImageManager()

    override func viewDidLoad() {
        super.viewDidLoad()
		tabBarVC = self.parent as? ProjectTabBarVC
		thisProject = tabBarVC.thisProject
		projectTitle.text = thisProject.name
		photos = RealmFuncs.Load.photos(of: thisProject)


//		let editBarButton = UIBarButtonItem(title: "Edit", style: .plain, target: nil, action: #selector(editModeSwitch))
//		navigationItem.setRightBarButtonItems([editBarButton], animated: true)
//		self.navigationItem.rightBarButtonItem = editBarButton

		
		let collectionFlowLayout = photosCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
		let cellSize = CGSize(width: ((photosCollectionView.frame.width - 6) / 3), height: ((photosCollectionView.frame.width - 6) / 3))
		collectionFlowLayout.itemSize = cellSize

		photoSize = CGSize(width: (cellSize.width * UIScreen.main.scale), height: (cellSize.width * UIScreen.main.scale))

		photosCollectionView.delegate = self
		photosCollectionView.dataSource = self
		photosCollectionView.register(UINib(nibName: K.CustomCells.photoCell, bundle: nil), forCellWithReuseIdentifier: K.CustomCells.photoCell)

	}

	@objc func editModeSwitch() {

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		syncRealmWithPhotos()
	}

	func syncRealmWithPhotos() {
		var photoIdentifiers: [String] = []
		for photo in photos {
			photoIdentifiers.append(photo.photoLocalIdentifier)
		}
		let options = PHFetchOptions()
		options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
		photoAssets = PHAsset.fetchAssets(withLocalIdentifiers: photoIdentifiers, options: options)
		photosCollectionView.reloadData()
	}
    


	@IBAction func addPhoto(_ sender: UIButton) {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "From Library", style: .default, handler: { _ in
			self.performSegue(withIdentifier: K.Segues.importPhotoSegue, sender: nil)
		}))

		alert.addAction(UIAlertAction(title: "From Camera", style: .default, handler: { _ in
		}))

		present(alert, animated: true, completion: nil)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is ImportPhotoVC {
			let dest = segue.destination as! ImportPhotoVC
			dest.thisProject = thisProject
			dest.photosVC = self
		}
	}


}

//MARK: -  COLLECTIONVIEW DATASOURCE AND DELEGATE
extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		return photoAssets == nil ? 0 : photoAssets.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CustomCells.photoCell, for: indexPath) as! PhotoCCC
		cell.photoView.contentMode = .scaleAspectFill
		imageManager.requestImage(for: photoAssets[indexPath.item], targetSize: photoSize, contentMode: .aspectFill, options: .none) { (image, _) in
			cell.photoView.image = image
			cell.imageIdentifier = self.photoAssets[indexPath.item].localIdentifier
		}
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		let cell = photosCollectionView.cellForItem(at: indexPath) as! PhotoCCC
		let contextMenu = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in

			let delete = UIAction(title: "Delete", attributes: .destructive) { _ in
				let photoObject = RealmFuncs.Search.photo(identifier: cell.imageIdentifier)
				cell.isHidden = true
				self.deleteAndReloadWithDelay(photoObject, indexPath)
				cell.isHidden = false
			}

			let thisMenu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [delete])
			return thisMenu
		}
		return contextMenu
	}

	func deleteAndReloadWithDelay(_ photo: Photo, _ indexPath: IndexPath) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			RealmFuncs.Edit.deleteObject(photo)
			self.syncRealmWithPhotos()

		}
	}


}
