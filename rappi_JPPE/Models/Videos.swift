//
//  Videos.swift
//  rappi_JPPE
//
//  Created by Jose Pablo Perez Estrada on 11/13/19.
//  Copyright © 2019 Jose Pablo Perez Estrada. All rights reserved.
//

import Foundation
import UIKit
import EVReflection


class modeloVideo : EVNetworkingObject {
    var id: Int = 0
    var results : [modeloResultsV] = [modeloResultsV]()
    
}// modelo de la respuesta de login

class modeloResultsV: EVNetworkingObject {
    var id : String = ""
    var iso_639_1 : String = ""
    var iso_3166_1 : String = ""
    var key : String = ""
    var name : String = ""
    var site : String = ""
    var size : Int = 0
    var type : String = ""
    
}







