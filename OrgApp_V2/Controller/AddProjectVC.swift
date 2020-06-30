import UIKit
import Firebase

class AddProjectVC: UIViewController {
	@IBOutlet weak var categoryTableView: UITableView!
	@IBOutlet weak var projNameField: UITextField!
	@IBOutlet weak var categorySearchField: UITextField!
	@IBOutlet weak var createProjectButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!

	var allCategorys: [FBCategory] = []
	var filteredCategorys: [FBCategory] = []
	var categoryRef: DatabaseReference!


	var projectsVC: ProjectsVC!
	var denyAddCategoryState: Bool = false
	

	override func viewDidLoad() {
        super.viewDidLoad()

		categoryRef = Database.database().reference().child(S.categorys)
		categoryRef.observeSingleEvent(of: .value) { (snap) in
			self.allCategorys.removeAll()
			for catSnapEnum in snap.children {
				let cat = catSnapEnum as! DataSnapshot
				self.allCategorys.append(FBCategory(uID: cat.key, name: cat.childSnapshot(forPath: S.name).value as! String))
			}
		}


		categoryTableView.delegate = self
		categoryTableView.dataSource = self
		categoryTableView.register(UINib(nibName: K.CustomCells.selectCategory, bundle: nil), forCellReuseIdentifier: K.CustomCells.selectCategory)

		categorySearchField.delegate = self
		categorySearchField.addTarget(self, action: #selector(didTypeSomething), for: UITextField.Event.editingChanged)
		categorySearchField.placeholder = "Type new Name or Select"

		projNameField.delegate = self
		projNameField.addTarget(self, action: #selector(didTypeSomething), for: UITextField.Event.editingChanged)
		projNameField.becomeFirstResponder()

		hideCategoryList(true)
		hideCreateProjectButton(true)
		denyAddCategory(true)
    }

	override func viewWillDisappear(_ animated: Bool) {
		projectsVC.projectsCollectionView.reloadData()
	}


}




//MARK: -  UITableView Delegate and DataSource
extension AddProjectVC: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return denyAddCategoryState ? (allCategorys.count) : (filteredCategorys.count + 1)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.CustomCells.selectCategory, for: indexPath) as! SelectCategoryTCC
		
		if denyAddCategoryState {
			cell.thisCategory = allCategorys[indexPath.row]
			cell.categoryLabel.text = cell.thisCategory.name
			cell.categoryLabel.textColor = .label
			cell.addCatButton.isHidden = true
			return cell
		}else {
			if indexPath.row == 0 {
				cell.categoryLabel.text = categorySearchField.text!
				cell.categoryLabel.textColor = .systemBlue
				cell.addCatButton.isHidden = false
			}else {
				cell.thisCategory = filteredCategorys[indexPath.row - 1]
				cell.categoryLabel.textColor = .label
				cell.categoryLabel.text = cell.thisCategory.name
				cell.addCatButton.isHidden = true
			}
			return cell
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if !denyAddCategoryState {
			if indexPath.row == 0 {
				allCategorys.append(FBCategory(uID: "Temp", name: categorySearchField.text!))
				categorySearchField.endEditing(true)
				denyAddCategory(true)
				hideCategoryList(true)
				_ = self.tryCheckOut()



			}else {
				categorySearchField.text = (categoryTableView.cellForRow(at: indexPath) as! SelectCategoryTCC).thisCategory.name
				categorySearchField.resignFirstResponder()
				hideCategoryList(true)
				_ = tryCheckOut()
			}
		}else {
			categorySearchField.text = (categoryTableView.cellForRow(at: indexPath) as! SelectCategoryTCC).thisCategory.name
			categorySearchField.resignFirstResponder()
			hideCategoryList(true)
			_ = tryCheckOut()
		}
	}


}


//MARK: -  UITextfield Delegate
extension AddProjectVC: UITextFieldDelegate {

	func textFieldDidBeginEditing(_ textField: UITextField) {
		denyAddCategory(true)

		switch textField {
		case categorySearchField:
			hideCreateProjectButton(true)
			hideCategoryList(false)
			if categorySearchField.text == "" {
				denyAddCategory(true)
			}else {
				filteredCategorys = FBK.Functions.returnCategoryWhich(contains: categorySearchField.text!, of: allCategorys)
				denyAddCategory(categoryExists(name: categorySearchField.text!))
			}
			categoryTableView.reloadData()

		case projNameField:
			_ = tryCheckOut()
			break
		default:
			break
		}
	}

	@objc func didTypeSomething(_ sender: UITextField) {
		switch sender {
		case categorySearchField:
			hideCategoryList(false)
			if categorySearchField.text == "" {
				denyAddCategory(true)
			}else {
				filteredCategorys = FBK.Functions.returnCategoryWhich(contains: categorySearchField.text!, of: allCategorys)
				denyAddCategory(categoryExists(name: categorySearchField.text!))
			}
			categoryTableView.reloadData()

		case projNameField:
			_ = tryCheckOut()

		default:
			break
		}
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == categorySearchField {
			if FBK.Functions.returnCategoryWhich(contains: categorySearchField.text!, of: allCategorys).count == 0 && categorySearchField.text != "" {
				allCategorys.append(FBCategory(uID: "Temp", name: categorySearchField.text!))
				denyAddCategory(true)
				hideCategoryList(true)
				_ = self.tryCheckOut()
			}
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if textField == projNameField && categorySearchField.text == "" {
			categorySearchField.becomeFirstResponder()
		}else {
			_ = tryCheckOut()
		}
		return true
	}


}

//MARK: -  User Actions and Functions
extension AddProjectVC {
	@IBAction func buttonPressed(_ sender: UIButton) {
		switch sender {
		case createProjectButton:
			exitAddProjectVC(save: true)

		case cancelButton:
			exitAddProjectVC(save: false)

		default:
			break
		}
	}

	func exitAddProjectVC(save: Bool) {
		if save {
			for tempCat in allCategorys.filter({ (cat) -> Bool in
				return cat.uID == "Temp"
			}) {
				tempCat.uID = FBK.Functions.createNewCategory(named: tempCat.name)

			}
			let selectedCat = allCategorys.filter { (cat) -> Bool in
				return cat.name == categorySearchField.text!
				}
			if selectedCat.count > 0 {
				FBK.Functions.createNewProject(named: projNameField.text!, in: selectedCat.first!)
			}
			projectsVC.projectsCollectionView.reloadData()
			self.dismiss(animated: true, completion: nil)

		}else {
			self.dismiss(animated: true, completion: nil)
		}

	}

	func categoryExists(name: String) -> Bool {
		return allCategorys.contains(where: { (cat) -> Bool in
			if cat.name == name {
				return true
			}else {
				return false
			}
		})
	}




	func hideCreateProjectButton(_ hide: Bool) {
		createProjectButton.isHidden = hide

	}

	func hideCategoryList(_ hide: Bool) {
		categoryTableView.isHidden = hide
	}

	func denyAddCategory(_ deny: Bool) {
		denyAddCategoryState = deny
	}

	func tryCheckOut() -> Bool {
		if categoryExists(name: categorySearchField.text!) && projNameField.text != "" {
			denyAddCategory(true)
			hideCategoryList(true)
			hideCreateProjectButton(false)
			return true
		}else {
			hideCategoryList(true)
			hideCreateProjectButton(true)
			return false
		}
	}
}













