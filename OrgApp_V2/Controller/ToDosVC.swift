import UIKit

class ToDosVC: UIViewController {
	@IBOutlet weak var toDosTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		toDosTableView.delegate = self
		toDosTableView.dataSource = self
		toDosTableView.register(UINib(nibName: K.toDoCell, bundle: nil), forCellReuseIdentifier: K.toDoCell)

    }


}


//MARK: -  TABLE VIEW DELEGATE AND DATASOURCE
extension ToDosVC: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.toDoCell, for: indexPath) as! ToDoTCC
		cell.toDoText.text = "Do To ?! -> \(indexPath.row)"
		return cell
	}


}
