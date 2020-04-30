import UIKit
import RealmSwift

class ProjectsVC: UIViewController {
	var orgaData = try! Realm()

	@IBOutlet weak var projectsCollectionView: UICollectionView!
	@IBOutlet weak var addProjectButton: UIButton!
	@IBOutlet weak var editProjectVCButton: UIBarButtonItem!

	var allProjects: Results<Project> = RealmFuncs.Load.projects()
	var allCategorys: Results<Category> = RealmFuncs.Load.categorys()
	var editMode: Bool = false

	let toDelete = Project()

	override func viewDidLoad() {
		super.viewDidLoad()

		allProjects = RealmFuncs.Load.projects()
		allCategorys = RealmFuncs.Load.categorys()

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


//MARK: -  USER INTERACTIVE FUNCTIONS
	@IBAction func editProjectsVC(_ sender: UIBarButtonItem) {
		if sender == editProjectVCButton {
			for categ in allCategorys {
				if categ.projects.count == 0  || editMode {
					changeEditMode(to: !editMode)
					break
				}
			}

		}
	}

	func changeEditMode(to mode: Bool) {
		editMode = mode
		if editMode {
			editProjectVCButton.image = nil
			editProjectVCButton.title = "Done"
			editProjectVCButton.tintColor = .systemRed
		}else {
			editProjectVCButton.title = ""
			editProjectVCButton.image = UIImage(systemName: "ellipsis")
			editProjectVCButton.tintColor = .systemBlue
		}
		projectsCollectionView.reloadData()
	}


	@IBAction func buttonPressed(_ sender: UIButton) {
		if sender == addProjectButton {
			changeEditMode(to: false)
			showAddProjectVC()
		}
	}

	func showAddProjectVC() {
		let addVC = AddProjectVC()
		addVC.projectsVC = self
		present(addVC, animated: true, completion: nil)
	}

	func showAddCategoryVC(with name: String?) {
		var categoryNameTextField = UITextField()
		let addCategory = UIAlertController(title: "New Category?", message: "Create a new Category", preferredStyle: .alert)

		addCategory.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
			if categoryNameTextField.text != "" {
				let newCat = Category()
				newCat.name = categoryNameTextField.text!
				_ = RealmFuncs.Save.object(object: newCat)
				self.projectsCollectionView.reloadData()
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
		changeEditMode(to: false)
		switch segue.identifier {
		case K.Segues.showProject:
			let tabBarVC = segue.destination as! ProjectTabBarVC
			tabBarVC.projectsVC = self
			tabBarVC.thisProject = sender as? Project

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
			if editMode && header.thisCategory.projects.count == 0 {
				header.deleteCategory.isHidden = false
				header.headerLabel.textColor = .systemRed
			}else {
				header.headerLabel.textColor = .secondaryLabel
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
		performSegue(withIdentifier: K.Segues.showProject, sender: (projectsCollectionView.cellForItem(at: indexPath) as! ProjectCCC).thisProject)

	}

	func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		if editMode {
			return nil
		}
		let thisCell = projectsCollectionView.cellForItem(at: indexPath) as! ProjectCCC

		let contextMenu = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
			let edit = UIAction(title: "Edit") { _ in
				thisCell.projectTitle.isUserInteractionEnabled = true
				thisCell.projectTitle.becomeFirstResponder()
			}

			let delete = UIAction(title: "Delete", attributes: .destructive) { _ in
				self.projectsCollectionView.cellForItem(at: indexPath)?.isHidden = true
				RealmFuncs.Edit.deleteObject(thisCell.thisProject)
				self.projectsCollectionView.deleteItems(at: [indexPath])


			}

			return UIMenu(title: "", image: nil, identifier: nil, options: .destructive, children: [edit, delete])
		}

		return contextMenu
	}


}


extension ProjectsVC: UIContextMenuInteractionDelegate {

	func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
		changeEditMode(to: false)
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




