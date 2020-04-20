import UIKit

class NotesVC: UIViewController {
	@IBOutlet weak var notesTableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		notesTableView.delegate = self
		notesTableView.dataSource = self
		notesTableView.register(UINib(nibName: K.noteCell, bundle: nil), forCellReuseIdentifier: K.noteCell)
    }


}


extension NotesVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.noteCell, for: indexPath) as! NoteTCC
		cell.noteTextField.text = "Cell -> \(indexPath.row)"
		return cell
	}


}
