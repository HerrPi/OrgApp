import UIKit
import RealmSwift

class NotesVC: UIViewController {
	@IBOutlet weak var notesTableView: UITableView!

	var tabBarVC: ProjectTabBarVC!
	var notes: List<Note>!
	var thisProject: Project!

	var hideContent: Bool = true
	var editNotesButton: UIBarButtonItem!

	
    override func viewDidLoad() {
        super.viewDidLoad()


		tabBarVC = self.parent as? ProjectTabBarVC
		thisProject = tabBarVC.thisProject
		notes = RealmFuncs.Load.notes(of: thisProject)
		title = thisProject.name

		notesTableView.rowHeight = UITableView.automaticDimension
		notesTableView.estimatedRowHeight = 600
		notesTableView.delegate = self
		notesTableView.dataSource = self
		notesTableView.register(UINib(nibName: K.CustomCells.noteCell, bundle: nil), forCellReuseIdentifier: K.CustomCells.noteCell)

		let tableTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTableNil))
		notesTableView.addGestureRecognizer(tableTapRecognizer)
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		hideContent = true
		notesTableView.reloadData()

		self.parent?.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Show note", style: .plain, target: self, action: #selector(previewNoteButton))]
		editNotesButton = self.parent?.navigationItem.rightBarButtonItem

	}


	@objc func previewNoteButton() {
		hideContent = !hideContent
		if hideContent {
			editNotesButton.title = "Show note"

		}else {
			editNotesButton.title = "Hide note"
		}

		notesTableView.reloadData()
	}


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == K.Segues.showNote {
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
			newNote.content = "Input Content here..."
			RealmFuncs.Edit.setParent(of: newNote, to: thisProject)
			performSegue(withIdentifier: K.Segues.showNote, sender: newNote)

		}else {
			performSegue(withIdentifier: K.Segues.showNote, sender: notesTableView.cellForRow(at: tappedIndexPath!))

		}
	}



}

//MARK: -  TABLE VIEW DELEGATE AND DATASOURCE
extension NotesVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notes.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.CustomCells.noteCell, for: indexPath) as! NoteTCC

		cell.thisNote = notes[indexPath.row]
		cell.titleLabel.text = cell.thisNote.title
		cell.contentPreviewLabel.text = cell.thisNote.content

		if hideContent {
			cell.contentPreviewLabel.isHidden = true
		}else {
			cell.contentPreviewLabel.isHidden = false

		}

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		notesTableView.deselectRow(at: indexPath, animated: true)
		performSegue(withIdentifier: K.Segues.showNote, sender: notesTableView.cellForRow(at: indexPath))

	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
			RealmFuncs.Edit.deleteObject((self.notesTableView.cellForRow(at: indexPath) as! NoteTCC).thisNote)
			self.notesTableView.deleteRows(at: [indexPath], with: .fade)
//			self.notesTableView.reloadData()
		}

		return UISwipeActionsConfiguration(actions: [delete])

	}



}



