import UIKit
import RealmSwift
import Photos

class PhotosVC: UIViewController {
	@IBOutlet weak var photosCollectionView: UICollectionView!

	var tabBarVC: ProjectTabBarVC!
	var thisProject: Project!
	var photos: List<Photo>!
	var photoAssets: PHFetchResult<PHAsset>!

	var photoSize = CGSize(width: 0, height: 0)
	var imageManager = PHImageManager()

	var deleteEditMode: Bool = false
	var editPhotosButton: UIBarButtonItem!

	var photoIdentifiers: [String] = []


    override func viewDidLoad() {
        super.viewDidLoad()
		tabBarVC = self.parent as? ProjectTabBarVC
		thisProject = tabBarVC.thisProject
		photos = RealmFuncs.Load.photos(of: thisProject)

		let collectionFlowLayout = photosCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
		let cellSize = CGSize(width: ((photosCollectionView.frame.width - 6) / 3), height: ((photosCollectionView.frame.width - 6) / 3))
		collectionFlowLayout.itemSize = cellSize

		photoSize = CGSize(width: (cellSize.width * UIScreen.main.scale), height: (cellSize.width * UIScreen.main.scale))

		photosCollectionView.delegate = self
		photosCollectionView.dataSource = self
		photosCollectionView.register(UINib(nibName: K.CustomCells.photoCell, bundle: nil), forCellWithReuseIdentifier: K.CustomCells.photoCell)
		photosCollectionView.allowsMultipleSelection = true

	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		syncRealmWithPhotos()
		self.parent?.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editThis))]
		editPhotosButton = self.parent?.navigationItem.rightBarButtonItem
		editPhotosButton.isEnabled = photos.count == 0 ? false : true
		changeEditMode(to: false)

	}

	@objc func editThis() {
		if deleteEditMode {
			for index in photosCollectionView.indexPathsForSelectedItems! {
				let cell = photosCollectionView.cellForItem(at: index) as! PhotoCCC
				let photoObject = RealmFuncs.Search.photo(identifier: cell.imageIdentifier)
				RealmFuncs.Edit.deleteObject(photoObject)
			}
			syncRealmWithPhotos()
			changeEditMode(to: !deleteEditMode)
		}else {
			changeEditMode(to: !deleteEditMode)
		}
	}

	func changeEditMode(to editMode: Bool) {
		if editMode {
			editPhotosButton.tintColor = .systemRed
			editPhotosButton.style = .done
			editPhotosButton.title = "Cancel"
			deleteEditMode = true
		}else {
			editPhotosButton.tintColor = .systemBlue
			editPhotosButton.style = .plain
			editPhotosButton.title = "Edit"
			deleteEditMode = false
		}
		editPhotosButton.isEnabled = photos.count == 0 ? false : true
		photosCollectionView.reloadData()
	}


	func syncRealmWithPhotos() {
		photoIdentifiers = []
		for photo in photos {
			photoIdentifiers.append(photo.photoLocalIdentifier)
		}
		let options = PHFetchOptions()
		options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
		photoAssets = PHAsset.fetchAssets(withLocalIdentifiers: photoIdentifiers, options: options)
		photosCollectionView.reloadData()
	}
    


	@IBAction func addPhoto(_ sender: UIButton) {
		changeEditMode(to: false)
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "From Library", style: .default, handler: { _ in
			self.performSegue(withIdentifier: K.Segues.importPhoto, sender: nil)
		}))

		alert.addAction(UIAlertAction(title: "From Camera", style: .default, handler: { _ in
		}))

		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

		


		present(alert, animated: true, completion: nil)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is ImportPhotoVC {
			let dest = segue.destination as! ImportPhotoVC
			dest.thisProject = thisProject
			dest.photosVC = self
		}

		if segue.destination is FullSizePhotoVC {
			let dest = segue.destination as! FullSizePhotoVC
			let indexPath = sender as! IndexPath
			dest.selectedPhoto = indexPath.item
			dest.photoAssets = photoAssets
			dest.photoIdentifiers = photoIdentifiers
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

		cell.selectOverlay.isHidden = !cell.isSelected

		return cell
	}


	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = photosCollectionView.cellForItem(at: indexPath) as! PhotoCCC
		if deleteEditMode {
			cell.selectOverlay.isHidden = false
			editPhotosButton.title = "Delete \(photosCollectionView.indexPathsForSelectedItems!.count) Photos!"
		}else {
			performSegue(withIdentifier: K.Segues.fullSizePhoto, sender: indexPath)
		}
	}

	func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
		let cell = photosCollectionView.cellForItem(at: indexPath) as! PhotoCCC
		cell.selectOverlay.isHidden = true
		return true
	}

	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		if photosCollectionView.indexPathsForSelectedItems?.count == 0 {
			editPhotosButton.title = "Cancel"
		}else {
			editPhotosButton.title = "Delete \(photosCollectionView.indexPathsForSelectedItems!.count) Photos!"
		}
	}



}

