import UIKit

class ProjectsVC: UIViewController {
	@IBOutlet weak var projectsCollectionView: UICollectionView!

	override func viewDidLoad() {
		super.viewDidLoad()
		projectsCollectionView.delegate = self
		projectsCollectionView.dataSource = self
		projectsCollectionView.register(UINib(nibName: K.projectCell, bundle: nil), forCellWithReuseIdentifier:K.projectCell)
	}


}



//MARK: -  COLLECTIONVIEW DATASOURCE AND DELEGATE
extension ProjectsVC: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.projectCell, for: indexPath) as! ProjectCCC
		cell.projectTitleLabel.text = "TESST"
		return cell
	}


}
