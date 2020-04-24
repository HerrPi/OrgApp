import UIKit
import RealmSwift

class NotesVC: UIViewController {
	var orgaData = try! Realm()

	@IBOutlet weak var notesTableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		print("Notes VC Load")

		notesTableView.delegate = self
		notesTableView.dataSource = self
		notesTableView.register(UINib(nibName: K.CustomCells.noteCell, bundle: nil), forCellReuseIdentifier: K.CustomCells.noteCell)
    }

}

//MARK: -  TABLE VIEW DELEGATE AND DATASOURCE
extension NotesVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.CustomCells.noteCell, for: indexPath) as! NoteTCC
		cell.noteTextField.text = "Cell -> \(indexPath.row)"
		return cell
	}


}
