

import UIKit
import RealmSwift

class ToDosVC: UITableViewController {
	@IBOutlet weak var toDosTableView: UITableView!
//
//	var tabBarVC: ProjectTabBarVC!
//	var thisProject: FBProject!
//	var doneToDos: List<DoneToDo>!
//	var unDoneToDos: List<UnDoneToDo>!
//	var hideDone: Bool = true
//	var activeCell: ToDoTCC?
//
//	var optionsBarButton: UIBarButtonItem!
//	var keyBoardToolBar = UIToolbar()


    override func viewDidLoad() {
        super.viewDidLoad()
//		tabBarVC = self.parent as? ProjectTabBarVC
//		thisProject = tabBarVC.thisProject
//		doneToDos = RealmFuncs.Load.doneToDos(of: thisProject)
//		unDoneToDos = RealmFuncs.Load.undDoneToDos(of: thisProject)
//
//		toDosTableView.register(UINib(nibName: K.CustomCells.toDoCell, bundle: nil), forCellReuseIdentifier: K.CustomCells.toDoCell)
//
//		let emptyTap = UITapGestureRecognizer(target: self, action: #selector(tapInTable))
//		toDosTableView.addGestureRecognizer(emptyTap)
//
//		keyBoardToolBar.sizeToFit()
//		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
//		keyBoardToolBar.setItems([flexibleSpace,doneButton], animated: true)
	}


//	override func viewWillAppear(_ animated: Bool) {
//		super.viewWillAppear(true)
//		self.parent?.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(optionsButton))]
//		optionsBarButton = self.parent?.navigationItem.rightBarButtonItem
//
//	}
//
//
//	@objc func optionsButton() {
//		if toDosTableView.isEditing {
//			toDosTableView.isEditing = !toDosTableView.isEditing
//			optionsBarButton.title = "..."
//
//		}else {
//
//			let optionsAlert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
//			let showHideDone = UIAlertAction(title: "Show Hide Done", style: .default) { (_) in
//				self.hideDone = !self.hideDone
//				self.toDosTableView.reloadData()
//			}
//
//			let rearrange = UIAlertAction(title: "Rearrange", style: .default) { (_) in
//				self.toDosTableView.isEditing = !self.toDosTableView.isEditing
//				self.optionsBarButton.title = "Done"
//			}
//
//			let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//			optionsAlert.addAction(showHideDone)
//			optionsAlert.addAction(rearrange)
//			optionsAlert.addAction(cancel)
//			present(optionsAlert, animated: true, completion: nil)
//		}
//
//
//
//
//	}
//
//
//	func switchCellDoneState(toDo: ToDo, cell: ToDoTCC) {
//		print(#function)
//		if activeCell == nil {
//			RealmFuncs.Edit.switchToDoDone(toDo, in: thisProject)
//			toDosTableView.reloadData()
//		}
//	}
//
//
//
//	func toDoInfoButton(toDo: ToDo){
//		deactivateCell(resign: true)
//		performSegue(withIdentifier: K.Segues.toDoDetail, sender: toDo)
//	}
//
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		if segue.destination is ToDoDetailVC {
//			let dest = segue.destination as! ToDoDetailVC
//			dest.thisToDo = sender as? ToDo
//			dest.toDosVC = self
//		}
//	}
//
//	//MARK: -  TABLE VIEW DELEGATE AND DATASOURCE
//	override func numberOfSections(in tableView: UITableView) -> Int {
//		return hideDone ? 1 : 2
//	}
//
//	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		switch section {
//		case 0:
//			return unDoneToDos.count
//		case 1:
//			return doneToDos.count
//		default:
//			return 0
//		}
//	}
//
//
//	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		switch section {
//		case 0:
//			return "To Do..."
//		case 1:
//			return hideDone ? "" : "...done!"
//		default:
//			return ""
//		}
//
//	}
//
//	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////		print("\(#function) -> \(indexPath)")
//
//		let cell = tableView.dequeueReusableCell(withIdentifier: K.CustomCells.toDoCell, for: indexPath) as! ToDoTCC
//		cell.toDosVC = self
//		switch indexPath.section {
//		case 0:
//			cell.showsReorderControl = tableView.isEditing ? true : false
//			cell.thisToDo = unDoneToDos[indexPath.row] // give Cell a referenced ToDo from ToDoArray
//			cell.toDoTitle.text = cell.thisToDo.name // set its title to the toDoName
//
//			if cell.thisToDo.toDoDescription == "" { // If there is no description, hide it
//				cell.descriptionLabel.isHidden = true
//			}else { // Or fill it and unHide it
//				cell.descriptionLabel.text = cell.thisToDo.toDoDescription
//				cell.descriptionLabel.isHidden = false
//			}
//
//			cell.doneButton.setBackgroundImage(UIImage(systemName: "circle"), for: .normal) // Mark CellDoneButton as unfilled
//			return cell
//
//		case 1:
//			cell.thisToDo = doneToDos[indexPath.row] // give Cell a referenced ToDo from ToDoarray
//			cell.toDoTitle.text = cell.thisToDo.name // show Title
//
//			if cell.thisToDo.toDoDescription == "" { // Description Hide
//				cell.descriptionLabel.isHidden = true
//			}else { // or noHide
//				cell.descriptionLabel.text = cell.thisToDo.toDoDescription
//				cell.descriptionLabel.isHidden = false
//			}
//
//			cell.doneButton.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal) // Fill DoneButton
//			return cell
//		default:
//			return cell
//		}
//
//	}
//
//	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//		if activeCell != nil {
//			return nil
//		}else {
//			let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
//				RealmFuncs.Edit.deleteObject((self.toDosTableView.cellForRow(at: indexPath) as! ToDoTCC).thisToDo)
//				self.toDosTableView.deleteRows(at: [indexPath], with: .none)
//			}
//
//			let config = UISwipeActionsConfiguration(actions: [delete])
//			return config
//		}
//
//	}
//
//	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//		return .none
//	}
//
//
//	override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//		return false
//	}
//
//	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//		let realm = try! Realm()
//		do {
//			try realm.write {
//				unDoneToDos.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
//			}
//		} catch  {
//			print("Error while Moveing -> \(error)")
//		}
//	}
//
//	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//		return true
//	}
//
//
//
//
//
//
//
//
//
//
//	@objc func tapInTable(gesture: UITapGestureRecognizer) {
//		if toDosTableView.indexPathForRow(at: gesture.location(in: toDosTableView)) == nil {
//			deactivateCell(resign: false)
//			createNewToDo(at: nil)
//		}
//
//	}
//
//	func createNewToDo(at row: Int?) {
//
////		print(#function)
//		let newtoDo = UnDoneToDo()
//		newtoDo.name = ""
//		newtoDo.toDoDescription = ""
//		RealmFuncs.Edit.setParent(of: newtoDo, to: thisProject)
//		let realm = try! Realm()
//		do {
//			try realm.write {
//				if row != nil {
//					unDoneToDos.move(from: unDoneToDos.index(of: newtoDo)!, to: row!)
//				}
//			}
//		} catch {
//			print("Error new ToDo -> \(error)")
//		}
//
//		toDosTableView.reloadData()
//		if let trueRow = row {
//			(toDosTableView.cellForRow(at: IndexPath(row: trueRow, section: 0)) as! ToDoTCC).toDoTitle.becomeFirstResponder()
//		}else {
//			let lastIndex = IndexPath(row: toDosTableView.numberOfRows(inSection: 0) - 1, section: 0)
//			(toDosTableView.cellForRow(at: lastIndex) as! ToDoTCC).toDoTitle.becomeFirstResponder()
//		}
//
//	}
//
//
//	func deactivateCell(resign: Bool) {
////		print(#function)
//
//		if activeCell != nil {
//			if resign {
//				print("RESIGN IT!!!!")
//				activeCell?.toDoTitle.resignFirstResponder()
//			}
//			activeCell = nil
//		}
//	}
//
//	@objc func doneButtonPressed() {
//		if activeCell != nil {
//			activeCell?.toDoTitle.resignFirstResponder()
//			activeCell = nil
//		}
//	}
//
//}
//
//
//
//
//extension ToDosVC: UITextFieldDelegate {
//	func textFieldShouldReturn(_ textField: UITextField, toDo: ToDo, cell: ToDoTCC) -> Bool {
////		print(#function)
//
//		if let cellIndexPath = toDosTableView.indexPath(for: cell) {
////			print("reuturn with cellIndexPath")
//			if textField.text == "" {
////				print("From Return -> resign true")
//				deactivateCell(resign: true)
//			}else {
////				print("From Return -> resign false")
//
//				deactivateCell(resign: false)
//				createNewToDo(at: cellIndexPath.row + 1)
//			}
//		}else {
////			print("return with no cellIndexPath -> resign true")
//			deactivateCell(resign: true)
//		}
//		return true
//	}
//
//
//
//	func textFieldDidEndEditing(_ textField: UITextField, toDo: ToDo, cell: ToDoTCC) {
////		print(#function)
//		cell.infoButton.isHidden = true
//
//		if textField.text == "" {
//			RealmFuncs.Edit.deleteObject(toDo)
//			if toDosTableView.visibleCells.contains(cell) {
//				toDosTableView.deleteRows(at: [toDosTableView.indexPath(for: cell)!], with: .left)
//			}
//			toDosTableView.reloadData()
//		}
//		optionsBarButton.isEnabled = true
//
//	}
//
//	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//		if toDosTableView.isEditing {
//			return false
//		}else {
//			textField.inputAccessoryView = keyBoardToolBar
//			return true
//		}
//	}
//
//	func textFieldDidBeginEditing(_ textField: UITextField, toDo: ToDo, cell: ToDoTCC) {
////		print(#function)
//		cell.infoButton.isHidden = false
//		optionsBarButton.isEnabled = false
//		activeCell = cell
//		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//			self.toDosTableView.scrollToRow(at: self.toDosTableView.indexPath(for: cell)!, at: .bottom, animated: false)
//		}
//	}
//
//
//	func textEditChanged(toDo: ToDo, text: String) {
////		print(#function)
//
//		RealmFuncs.Edit.renameToDo(toDo, newName: text)
//	}
//
}
//
//
