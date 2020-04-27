import UIKit
import RealmSwift

class NotesVC: UIViewController {
	@IBOutlet weak var notesTableView: UITableView!

	var tabBarVC: ProjectTabBarVC!
	var notes: List<Note>!
	var thisProject: Project!

	var contentState: Bool = false

	
    override func viewDidLoad() {
        super.viewDidLoad()


		tabBarVC = self.parent as? ProjectTabBarVC
		thisProject = tabBarVC.thisProject
		notes = RealmFuncs.Load.notes(of: thisProject)

//		let newNote = Note()
//		newNote.title = "Test Note"
//		newNote.content = "Das ist der Content of der speziellen Note..."
//		RealmFuncs.Save.object(object: newNote)
//		RealmFuncs.Edit.setParent(of: newNote, to: thisProject)


		notesTableView.delegate = self
		notesTableView.dataSource = self
		notesTableView.register(UINib(nibName: K.CustomCells.noteCell, bundle: nil), forCellReuseIdentifier: K.CustomCells.noteCell)


		let tableTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTableNil))
		notesTableView.addGestureRecognizer(tableTapRecognizer)
    }

	override func viewWillAppear(_ animated: Bool) {
		notesTableView.reloadData()
	}


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == K.Segues.showNoteSegue {
			let noteDetail = segue.destination as! NoteDetailVC
			noteDetail.thisProject = thisProject
			if sender is NoteTCC {
				noteDetail.thisNote = (sender as! NoteTCC).thisNote
			}else {
				noteDetail.thisNote = sender as? Note
			}
			
			
		}
	}

	@objc func tapTableNil(tap: UITapGestureRecognizer) {
		let tappedIndexPath: IndexPath? = notesTableView.indexPathForRow(at: tap.location(in: notesTableView))
		if tappedIndexPath == nil {
			let newNote = Note()
			newNote.title = ""
			newNote.content = "Your Content..."
			RealmFuncs.Edit.setParent(of: newNote, to: thisProject)
			performSegue(withIdentifier: K.Segues.showNoteSegue, sender: newNote)

		}else {
			performSegue(withIdentifier: K.Segues.showNoteSegue, sender: notesTableView.cellForRow(at: tappedIndexPath!))

		}
	}

	@IBAction func showContent(_ sender: UIButton) {
		contentState = !contentState

		if contentState {
			sender.setTitleColor(.red, for: .normal)
		}else {
			sender.setTitleColor(.blue, for: .normal)
		}

		notesTableView.reloadData()

	}
}

//MARK: -  TABLE VIEW DELEGATE AND DATASOURCE
extension NotesVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notes.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.CustomCells.noteCell, for: indexPath) as! NoteTCC
		print(cell.textContainer.frame.height)
		cell.thisNote = notes[indexPath.row]
		cell.titleLabel.text = cell.thisNote.title
		cell.contentPreviewLabel.text = cell.thisNote.content
				print(cell.textContainer.frame.height)

//		if contentState {
//			cell.contentPreviewLabel.isHidden = true
//		} else {
//			cell.contentPreviewLabel.isHidden = false
//
//		}
		return cell
	}



}



