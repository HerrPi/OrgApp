import UIKit
import RealmSwift

class ToDosVC: UIViewController {
	@IBOutlet weak var toDosTableView: UITableView!

	var allProjects: Results<Project> = RealmFuncs.Load.projects()
	var toDos: Results<ToDo> = RealmFuncs.Load.toDos()

    override func viewDidLoad() {
        super.viewDidLoad()
		print("ToDo VC Load")
		toDosTableView.delegate = self
		toDosTableView.dataSource = self
		toDosTableView.register(UINib(nibName: K.CustomCells.toDoCell, bundle: nil), forCellReuseIdentifier: K.CustomCells.toDoCell)

    }


}


//MARK: -  TABLE VIEW DELEGATE AND DATASOURCE
extension ToDosVC: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.CustomCells.toDoCell, for: indexPath) as! ToDoTCC
		cell.toDoText.text = "Do To ?! -> \(indexPath.row)"
		return cell
	}


}
