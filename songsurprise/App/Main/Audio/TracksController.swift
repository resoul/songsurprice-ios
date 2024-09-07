//
//  TracksController.swift
//  songsurprise
//
//  Created by resoul on 07.09.2024.
//

import UIKit

class TracksController: UIViewController {
    
    private var genre: Genre
    private var tracks: [Track] = []
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(cell: TracksItemView.self)
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    init(genre: Genre) {
        self.genre = genre
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = genre.name
        
        view.addSubview(tableView)
        tableView.constraints(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        Task {
            tracks = try await Client.http.supabase()
                .from("songs")
                .select()
                .eq("genre_id", value: genre.id)
                .execute()
                .value
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TracksController: TableViewProvider {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TracksItemView.self)
        cell.accessoryType = .disclosureIndicator
        cell.configure(tracks[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        present(PlayerController(index: indexPath.row, tracks: tracks), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
