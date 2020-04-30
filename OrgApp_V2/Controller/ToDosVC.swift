import UIKit
import RealmSwift

class ToDosVC: UIViewController {
	@IBOutlet weak var toDosTableView: UITableView!

	var tabBarVC: ProjectTabBarVC!
	var thisProject: Project!
	var doneToDos: Results<ToDo>!
	var unDoneToDos: Results<ToDo>!
	var hideDone: Bool = true

	var editToDosButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
		tabBarVC = self.parent as? ProjectTabBarVC
		thisProject = tabBarVC.thisProject
		doneToDos = RealmFuncs.Load.doneToDos(of: thisProject)
		unDoneToDos = RealmFuncs.Load.undDoneToDos(of: thisProject)

		toDosTableView.delegate = self
		toDosTableView.dataSource = self
		toDosTableView.register(UINib(nibName: K.CustomCells.toDoCell, bundle: nil), forCellReuseIdentifier: K.CustomCells.toDoCell)

		let emptyTap = UITapGestureRecognizer(target: self, action: #selector(tapInTable))
		toDosTableView.addGestureRecognizer(emptyTap)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		self.parent?.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Show Done", style: .plain, target: self, action: #selector(showHidePressed))]
		editToDosButton = self.parent?.navigationItem.rightBarButtonItem
	}

	@objc func showHidePressed() {
		hideDone = !hideDone
		hideDone ? (editToDosButton.title = "Show Done") : (editToDosButton.title = "Hide Done")
		toDosTableView.reloadData()
	}


	func markCellDoneUndone (cell: ToDoTCC) {
		let cellIndex = toDosTableView.indexPath(for: cell)
		RealmFuncs.Edit.switchToDoDone(cell.thisToDo, done: !cell.thisToDo.done)
		if cell.thisToDo.done {
			if !hideDone {
				toDosTableView.moveRow(at: cellIndex!, to: IndexPath(row: doneToDos.index(of: cell.thisToDo)!, section: 1))
			}
		}else {
			toDosTableView.moveRow(at: cellIndex!, to: IndexPath(row: unDoneToDos.index(of: cell.thisToDo)!, section: 0))
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.toDosTableView.reloadData()
		}
	}

}


//MARK: -  TABLE VIEW DELEGATE AND DATASOURCE
extension ToDosVC: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return hideDone ? 1 : 2
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return unDoneToDos.count
		case 1:
			return doneToDos.count
		default:
			return 0
		}
	}


	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "To Do..."
		case 1:
			return hideDone ? "" : "...done!"
		default:
			return ""
		}

	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.CustomCells.toDoCell, for: indexPath) as! ToDoTCC
		cell.toDosVC = self
		switch indexPath.section {
		case 0:
			cell.thisToDo = unDoneToDos[indexPath.row]
			cell.toDoText.text = cell.thisToDo.name
			cell.doneButton.setImage(UIImage(systemName: "circle"), for: .normal)
			return cell
		case 1:
			cell.thisToDo = doneToDos[indexPath.row]
			cell.toDoText.text = cell.thisToDo.name
			cell.doneButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
			cell.isHidden = hideDone ? true : false
			return cell
		default:
			return cell
		}

	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
			RealmFuncs.Edit.deleteObject((self.toDosTableView.cellForRow(at: indexPath) as! ToDoTCC).thisToDo)
			self.toDosTableView.deleteRows(at: [indexPath], with: .none)
		}

		let moreInfo = UIContextualAction(style: .normal, title: "More...") { (_, _, _) in
			print("More Info")
		}
		let config = UISwipeActionsConfiguration(actions: [delete, moreInfo])
		return config
	}



	@objc func tapInTable(gesture: UITapGestureRecognizer) {
		if toDosTableView.indexPathForRow(at: gesture.location(in: toDosTableView)) == nil {
			let newToDo = ToDo()
			newToDo.name =  "New ToDo"
			newToDo.done = false
			_ = RealmFuncs.Save.object(object: newToDo)
			RealmFuncs.Edit.setParent(of: newToDo, to: thisProject)
			let lastIndex = IndexPath(row: toDosTableView.numberOfRows(inSection: 0), section: 0)
			toDosTableView.insertRows(at: [lastIndex], with: .bottom)
			(toDosTableView.cellForRow(at: IndexPath(row: lastIndex.row, section: 0)) as! ToDoTCC).toDoText.text = ""
			(toDosTableView.cellForRow(at: IndexPath(row: lastIndex.row, section: 0)) as! ToDoTCC).toDoText.becomeFirstResponder()

		}

	}







}


extension ToDosVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField, toDo: ToDo) -> Bool {
		textField.endEditing(true)
		textField.resignFirstResponder()
		return true
	}

	func textFieldDidEndEditing(_ textField: UITextField, toDo: ToDo, cell: ToDoTCC) {
		if textField.text != "" {
			let sourcePath = toDosTableView.indexPath(for: cell)
			RealmFuncs.Edit.renameToDo(toDo, newName: textField.text!)
			if toDo.done {
				if !hideDone {
					toDosTableView.moveRow(at: sourcePath!, to: IndexPath(row: doneToDos.index(of: toDo)!, section: 1))
				}
			}else {
				toDosTableView.moveRow(at: sourcePath!, to: IndexPath(row: unDoneToDos.index(of: toDo)!, section: 0))
			}

		}else {
			RealmFuncs.Edit.deleteObject(toDo)
			toDosTableView.deleteRows(at: [toDosTableView.indexPath(for: cell)!], with: .left)
		}
		editToDosButton.isEnabled = true
	}

	func textFieldDidBeginEditing(_ textField: UITextField, toDo: ToDo) {
		editToDosButton.isEnabled = false
	}

}
