//
//  ViewController.swift
//  rappi_JPPE
//
//  Created by Jose Pablo Perez Estrada on 11/13/19.
//  Copyright © 2019 Jose Pablo Perez Estrada. All rights reserved.
//

import UIKit
import SQLite3
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    struct Categ {
        var cat : String = ""
        var index : Int = 0
    }
    
    var cat : [Categ] = []
    var temp : Categ = Categ()
    var catSelected = 0
    var peliculas : modeloCategoria = modeloCategoria()
    @IBOutlet weak var tableView: UITableView!
    
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    var filteredExercises = [Categ]()
    
    var url = ["https://api.themoviedb.org/3/movie/top_rated?api_key=a33bf35bccf09ae8497eee5e118a2631&language=en-US&page=1","https://api.themoviedb.org/3/movie/popular?api_key=a33bf35bccf09ae8497eee5e118a2631&language=en-US&page=1","https://api.themoviedb.org/3/movie/upcoming?api_key=a33bf35bccf09ae8497eee5e118a2631&language=en-US&page=1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        temp.cat="Top rated"
        temp.index = 1
        cat.append(temp)
        
        temp.cat="Popular"
        temp.index = 2
        cat.append(temp)
        
        temp.cat="Upcoming"
        temp.index = 3
        cat.append(temp)
        
        self.creatingSearhBar()
        self.tableSettings()
        if BD().contarPelis() == 0 {
            for (index, element) in url.enumerated() {
                getDatos(url: element, categoria: index + 1)
            }
        }
        else{
            print("ya hay registros")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return cat.count
        }
        else {
            return filteredExercises.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "categoriaCell", for: indexPath) as! CategoriasTableViewCell
        
        if tableView == self.tableView {
            cell.lblCategoria.text = cat[indexPath.row].cat
        }else{
            cell.lblCategoria.text = filteredExercises[indexPath.row].cat
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            catSelected = cat[indexPath.row].index
        }else{
            catSelected = filteredExercises[indexPath.row].index
        }
        performSegue(withIdentifier: "toCategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //  let controller = segue.destination as! HomeViewController
        let detailsView = segue.destination as! CategoryViewController
        detailsView.categoria = catSelected
    }
    
    
    func getDatos(url : String, categoria : Int){
        Alamofire.request(url,method : .get).responseObject{(response:DataResponse<modeloCategoria>) in
            // aqui codigo para la validacion
            if let result = response.result.value{
                for peli in result.results{
                    BD().insertPeli(id: String(peli.id), title: peli.title, vote_count: String(peli.vote_count), vote_average: String(peli.vote_average), overview: peli.overview, poster_path: peli.poster_path, backdrop_path: peli.backdrop_path, release_date: peli.release_date, category : String(categoria))
                }
            }
            else{
                print ("error")
            }
        }
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
        self.filteredExercises = self.cat.filter { (exercise: Categ) -> Bool in
            if exercise.cat.lowercased().contains(self.searchController.searchBar.text!.lowercased()){
                return true
            } else{
                return false
            }
        }
        self.resultsController.tableView.reloadData()
        
    }
    
    


}

