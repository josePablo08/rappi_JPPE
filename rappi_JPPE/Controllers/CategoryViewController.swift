//
//  CategoryViewController.swift
//  rappi_JPPE
//
//  Created by Jose Pablo Perez Estrada on 11/13/19.
//  Copyright © 2019 Jose Pablo Perez Estrada. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var idSeleccionado = 0
    var categoria = 0
    
    var datosPelis =  BD().consultarXcategoria(id: 0)
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    var filteredExercises = [datos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.creatingSearhBar()
        self.tableSettings()
        switch categoria {
        case 1:
            navigationBar.topItem?.title = "TOP RATED"
        case 2:
            navigationBar.topItem?.title = "POPULAR"
        case 3:
            navigationBar.topItem?.title = "UPCOMING"
        default:
            navigationBar.topItem?.title = "ERROR"
        }
        self.datosPelis = BD().consultarXcategoria(id: categoria)
        tableView.reloadData()
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return self.datosPelis.count
        }
        else {
            return filteredExercises.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "itemCategory", for: indexPath) as! MoviesTableViewCell
        
        if tableView == self.tableView {
            cell.nameMovie.text = datosPelis[indexPath.row].title
            cell.voteMovie.text = String(datosPelis[indexPath.row].vote_count)
            cell.dateMovie.text = datosPelis[indexPath.row].release_date
            cell.imgMovie.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" +  datosPelis[indexPath.row].poster_path))
        }else{
            cell.nameMovie.text = filteredExercises[indexPath.row].title
            cell.voteMovie.text = String(filteredExercises[indexPath.row].vote_count)
            cell.dateMovie.text = filteredExercises[indexPath.row].release_date
            cell.imgMovie.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" +  filteredExercises[indexPath.row].poster_path))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            idSeleccionado = datosPelis[indexPath.row].id
        }else{
            idSeleccionado = filteredExercises[indexPath.row].id
            
        }
        
       // idSeleccionado = datosPelis[indexPath.row].id
        performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsView = segue.destination as! DetailsViewController
        detailsView.indexSelection = idSeleccionado
        
    }
    
    
    func creatingSearhBar() {
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
    }
    
    func tableSettings() {
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        self.resultsController.tableView.rowHeight = 204
        self.resultsController.tableView.separatorStyle = .none
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredExercises = self.datosPelis.filter { (exercise: datos) -> Bool in
            if exercise.title.lowercased().contains(self.searchController.searchBar.text!.lowercased()){
                return true
            } else{
                return false
            }
        }
        self.resultsController.tableView.reloadData()
        
    }
    
    
    
    
    
    
}
