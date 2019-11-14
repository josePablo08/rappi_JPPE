//
//  DetailsViewController.swift
//  rappi_JPPE
//
//  Created by Jose Pablo Perez Estrada on 11/13/19.
//  Copyright © 2019 Jose Pablo Perez Estrada. All rights reserved.
//

import UIKit
import Kingfisher.Kingfisher
import YouTubePlayer
import Alamofire



class DetailsViewController: UIViewController {
    
    //var peliculas : modeloCategoria = modeloCategoria()
    var indexSelection = 0
    var datosPeli =  BD().consultarXid(id: 0)
    @IBOutlet weak var videoView: YouTubePlayerView!
    
    @IBOutlet weak var principalImg: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tittleLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var votesLbl: UILabel!
    @IBOutlet weak var reviewLbl: UILabel!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var btnCV: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoView.isHidden = true
        btnCV.isHidden = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datosPeli = BD().consultarXid(id: indexSelection)
        print (datosPeli)
       date.text = datosPeli.release_date
        tittleLbl.text = datosPeli.title
        rateLbl.text = String(datosPeli.vote_average)
        votesLbl.text = String(datosPeli.vote_count)
        reviewLbl.text = datosPeli.overview
        principalImg.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" +  datosPeli.backdrop_path))
        img2.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" +  datosPeli.poster_path))
        getVideo(id: datosPeli.id)
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func trailer(_ sender: Any) {
        videoView.isHidden = false
        btnCV.isHidden = false
    }
    
    @IBAction func cerrarVideo(_ sender: Any) {
        videoView.isHidden = true
        btnCV.isHidden = true
    }
    
    
    func getVideo(id : Int){
        var idV = ""
        let url = "https://api.themoviedb.org/3/movie/" + String(id) + "/videos?api_key=a33bf35bccf09ae8497eee5e118a2631"
        print(":::::::::::")
        print (url)
        Alamofire.request(url,method : .get).responseObject{(response:DataResponse<modeloVideo>) in
            // aqui codigo para la validacion
            if let result = response.result.value{
                print(result.results[0].key)
                self.videoView.loadVideoID(idV)
            }
            else{
                print ("error")
            }
        }
    
    }
    
    

}
