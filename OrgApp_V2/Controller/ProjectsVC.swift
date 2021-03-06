import UIKit
//import RealmSwift
import Firebase

class ProjectsVC: UIViewController {
	@IBOutlet weak var projectsCollectionView: UICollectionView!
	@IBOutlet weak var addProjectButton: UIButton!
	@IBOutlet weak var dummyButton: UIBarButtonItem!


	var allCategorys: [FBCategory] = []



	override func viewDidLoad() {
		super.viewDidLoad()

		let loadCategoryDispatcher = DispatchGroup()
		loadCategoryDispatcher.enter()
		FBK.Categorys.loadAllCategorysAndProjects(projectsVC: self, loadingDispatcher: loadCategoryDispatcher)
		loadCategoryDispatcher.notify(queue: .main) {
			FBK.Categorys.childAddedObserver(projectsVC: self)
			FBK.Categorys.childRemovedObserver(projectsVC: self)
			FBK.Projects.childAddedObserver(projectsVC: self)
			FBK.Projects.childRemovedObserver(projectsVC: self)
			self.projectsCollectionView.reloadData()
		}

		projectsCollectionView.delegate = self
		projectsCollectionView.dataSource = self
		projectsCollectionView.register(UINib(nibName: K.CustomCells.projectCell, bundle: nil), forCellWithReuseIdentifier: K.CustomCells.projectCell)
		projectsCollectionView.register(UINib(nibName: K.CustomCells.projectHeader, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.CustomCells.projectHeader)
		projectsCollectionView.register(UINib(nibName: K.CustomCells.projectFooter, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter , withReuseIdentifier: K.CustomCells.projectFooter)
		let collectionFlowLayout = projectsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
		collectionFlowLayout.itemSize = CGSize(width: ((view.frame.size.width - 20) / 3), height: ((view.frame.size.width - 20) / 3))

		let addProjCatContext = UIContextMenuInteraction(delegate: self)
		addProjectButton.addInteraction(addProjCatContext)





	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)

	}

	@IBAction func dummyButtonPressed(_ sender: UIBarButtonItem) {
//		var dataBase =  Database.database().reference().child("TestArea")
//		dataBase.child("Counter \(upCounter)").setValue("Debug Down \(downCounter)", andPriority: downCounter) { (_, _) in
//			self.downCounter -= 1
//			self.upCounter += 1
//		}

//		dataBase.child("Counter \(upCounter)").setValue("Debug Down \(downCounter)") { (_, _) in
//			self.downCounter -= 1
//			self.upCounter += 1
//		}
		print(allCategorys.count)
	}

//MARK: -  USER INTERACTIVE FUNCTIONS
	@IBAction func buttonPressed(_ sender: UIButton) {
		if sender == addProjectButton {
			showAddProjectVC()
		}
	}

	func showAddProjectVC() {
		let addVC = AddProjectVC()
		addVC.projectsVC = self
		addVC.allTempCategorys = allCategorys
		present(addVC, animated: true, completion: nil)
	}

	func showAddCategoryVC(with name: String?) {
		var categoryNameTextField = UITextField()
		let addCategory = UIAlertController(title: "New Category?", message: "Create a new Category", preferredStyle: .alert)

		addCategory.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
			if categoryNameTextField.text != "" {
				_ = FBK.Categorys.createNewCategory(named: categoryNameTextField.text!)
			}else {
				let noNameGiven = UIAlertController(title: "No Name Given", message: "You have to give a name - canceled", preferredStyle: .alert)
				noNameGiven.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in self.showAddCategoryVC(with: nil)}))
				self.present(noNameGiven, animated: true, completion: nil)
			}
		}))
		addCategory.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))


		addCategory.addTextField { (textField) in
			textField.text = name
			textField.autocapitalizationType = .words
			categoryNameTextField = textField
		}

		present(addCategory, animated: true, completion: nil)



	}


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case K.Segues.showProject:
			let tabBarVC = segue.destination as! ProjectTabBarVC
			tabBarVC.projectsVC = self
			tabBarVC.thisProject = Database.database().reference().child("\(S.projects)/\(sender as! String)")

		default:
			break
		}
	}


}



//MARK: -  COLLECTIONVIEW DATASOURCE AND DELEGATE
extension ProjectsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

//MARK: - COLLECTIONVIEW CONFIGURATION
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: K.CustomCells.projectHeader, for: IndexPath(row: 0, section: section)) as! ProjectHeaderCHC
		return header.headerLabel.frame.size
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: K.CustomCells.projectFooter, for: IndexPath(row: 0, section: section)) as! ProjectFooterCFC
		return footer.blackSeperator.frame.size
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return allCategorys.count
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return allCategorys[section].projects.count

	}

//MARK: - COLLECTIONVIEW FILLING
	// HEADER AND FOOTER
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: K.CustomCells.projectHeader, for: indexPath) as! ProjectHeaderCHC
			header.thisCategory = allCategorys[indexPath.section]
			header.headerLabel.text = header.thisCategory.name
			header.headerLabel.textColor = .secondaryLabel

			header.projectsVC = self

			if header.thisCategory.projects.count == 0 {
				header.deleteCategory.isHidden = false
			}else {
				header.deleteCategory.isHidden = true
			}

			header.backgroundColor = .none
			return header

		case UICollectionView.elementKindSectionFooter:
			let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: K.CustomCells.projectFooter, for: indexPath) as! ProjectFooterCFC
			return footer
		default:
			break
		}
		return UICollectionReusableView()
	}


	// CELLS AND ITEMS
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CustomCells.projectCell, for: indexPath) as! ProjectCCC
		cell.isHidden = false
		cell.thisProject = allCategorys[indexPath.section].projects[indexPath.row]
		cell.projectsVC = self
		cell.projectTitle.text = cell.thisProject.name
		cell.projectTitle.backgroundColor = .systemOrange
		return cell
	}



	// COLLECTION FUNCTIONS
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		performSegue(withIdentifier: K.Segues.showProject, sender: (projectsCollectionView.cellForItem(at: indexPath) as! ProjectCCC).thisProject.uID)
	}

	func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		let thisCell = projectsCollectionView.cellForItem(at: indexPath) as! ProjectCCC

		let contextMenu = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
			let edit = UIAction(title: "Edit") { _ in
				thisCell.projectTitle.isUserInteractionEnabled = true
				thisCell.projectTitle.becomeFirstResponder()

			}

			let delete = UIAction(title: "Delete", attributes: .destructive) { _ in
				self.projectsCollectionView.cellForItem(at: indexPath)?.isHidden = true
				FBK.Projects.deleteProject(project: thisCell.thisProject)

			}

			return UIMenu(title: "", image: nil, identifier: nil, options: .destructive, children: [edit, delete])
		}

		return contextMenu
	}


}


extension ProjectsVC: UIContextMenuInteractionDelegate {

	func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
		projectsCollectionView.reloadData()

		let contextMenu = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
			let addProject = UIAction(title: "Add Project") { _ in
				self.showAddProjectVC()
			}
			let addCategory = UIAction(title: "Add Category") { _ in
				self.showAddCategoryVC(with: nil)
			}

			return UIMenu(title: "", image: nil, identifier: nil, children: [addProject, addCategory])
		}
		return contextMenu
	}
}




