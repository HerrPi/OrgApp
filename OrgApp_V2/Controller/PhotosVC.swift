
import UIKit

class PhotosVC: UIViewController {
	@IBOutlet weak var photosCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
		photosCollectionView.delegate = self
		photosCollectionView.dataSource = self
		photosCollectionView.register(UINib(nibName: K.photoCell, bundle: nil), forCellWithReuseIdentifier: K.photoCell)

    }
    


}


extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.photoCell, for: indexPath) as! PhotoCCC
		return cell
	}


}
