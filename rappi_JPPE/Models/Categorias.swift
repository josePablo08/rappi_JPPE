//
//  Categorias.swift
//  rappi_JPPE
//
//  Created by Jose Pablo Perez Estrada on 11/13/19.
//  Copyright © 2019 Jose Pablo Perez Estrada. All rights reserved.
//

import Foundation
import UIKit
import EVReflection


class modeloCategoria : EVNetworkingObject {
    var page: Int = 0
    var total_results: Int = 0
    var total_pages: Int = 0
    var results : [modeloResults] = [modeloResults]()

}// modelo de la respuesta de login


class modeloResults: EVNetworkingObject {
    var popularity : Int = 0
    var vote_count : Int = 0
    var video : Bool = false
    var poster_path : String = ""
    var id : Int = 0
    var adult : Bool = false
    var backdrop_path : String = ""
    var original_lenguage : String = ""
    var original_title : String = ""
    var genre_ids : [Int] = []
    var title : String = ""
    var vote_average : Float = 0.0
    var overview : String = ""
    var release_date : String = ""
}




struct datos {
    var  id = 0
    var title = ""
    var vote_count = 0
    var vote_average = ""
    var overview = ""
    var poster_path = ""
    var backdrop_path = ""
    var release_date = ""
    var category = ""
}


