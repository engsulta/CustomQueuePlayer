//
//  MessagesTableViewController.swift
//  JBMultiAudioPlayers
//
//  Created by Ahmed Sultan on 1/4/20.
//  Copyright © 2020 hamza. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {
    let sources: [String] = ["https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3",
    "https://p.scdn.co/mp3-preview/bf9bdd403c67fdbe06a582e7b292487c8cfd1f7e?cid=d8a5ed958d274c2e8ee717e6a4b0971d",
    "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_1MG.mp3",]
    var audioController: JBAudioController2 = JBAudioController2()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        tableView.register(UINib(nibName: "MessageAudioCell", bundle: nil), forCellReuseIdentifier: "MessageAudioCell")
        //tableView.register(MessageAudioCell.self, forCellReuseIdentifier: "MessageAudioCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension // self sizing
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 16, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sources.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageAudioCell = tableView.dequeueReusableCell(withIdentifier: "MessageAudioCell", for: indexPath) as! MessageAudioCell
        // cell configure
        cell.audioPlayerDelegate = audioController
        cell.msgURL = sources[indexPath.row]
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
