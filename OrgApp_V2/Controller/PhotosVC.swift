import UIKit
import RealmSwift

class PhotosVC: UIViewController {
	var orgaData = try! Realm()
	
	@IBOutlet weak var photosCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
		print("Photos VC Load")

		photosCollectionView.delegate = self
		photosCollectionView.dataSource = self
		photosCollectionView.register(UINib(nibName: K.CustomCells.photoCell, bundle: nil), forCellWithReuseIdentifier: K.CustomCells.photoCell)

    }
    


}

//MARK: -  COLLECTIONVIEW DATASOURCE AND DELEGATE
extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CustomCells.photoCell, for: indexPath) as! PhotoCCC
		return cell
	}


}
