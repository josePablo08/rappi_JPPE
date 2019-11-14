//
//  db.swift
//
//
//  Created by Jose Pablo Perez Estrada on 11/5/19.
//  Copyright © 2019 Jose Pablo Perez Estrada. All rights reserved.
//


import Foundation
import SQLite3

class BD {
    var db : OpaquePointer?
    var stmt : OpaquePointer?
    
    init() {
        crearBD()
        let fileURL = try!
            FileManager.default.url (for: .documentDirectory, in: .userDomainMask, appropriateFor : nil, create : false ).appendingPathComponent("movieDB2.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print ("no se pude abrir la base de datos")
        }else {//print ("se abrio la bd")
            
        }
    }
    
    
    // crear DB para almacenar datos de las peliculas
    func crearBD (){
        let fileURL = try!
            FileManager.default.url (for: .documentDirectory, in: .userDomainMask, appropriateFor : nil, create : false ).appendingPathComponent("movieDB2.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print ("no se pude abrir la base de datos")
        }
        let createTableQuery = "CREATE TABLE IF NOT EXISTS peliculas (id INTEGER, title CHAR(48), vote_count Integer, vote_average CHAR(10), overview CHAR(500), poster_path CHAR(300), backdrop_path CHAR(300), release_date CHAR(16), category INT)"
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print ("error al crear la table ")
        }
        else {
            print ("se creo la table \"peliculas \" ")
            
        }
        sqlite3_close(db)
    }
    
    
    
    func insertPeli(id : String, title : String, vote_count : String, vote_average : String, overview : String, poster_path : String, backdrop_path : String, release_date : String, category : String){ // funcion para guardar los datos en la BD
        //  let insertQuery = "INSERT INTO orden (idProducto, cantidad) VALUES (? , ?)"
        // agregar un id autoincrementable para poder eliminar despues un elemento del pedido
        let titleL: NSString = title as NSString
        let vote_averageL: NSString = vote_average as NSString
        let overviewL: NSString = overview as NSString
        let poster_pathL: NSString = poster_path as NSString
        let backdrop_pathL: NSString = backdrop_path as NSString
        let release_dateL: NSString = release_date as NSString
        
        
        
        let insertQuery = "INSERT INTO peliculas (id , title , vote_count , vote_average , overview , poster_path , backdrop_path , release_date, category) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK {
            print ("binding query")
        }
        if sqlite3_bind_int(stmt, 1, (id as NSString).intValue) != SQLITE_OK{
            print ("se cargo correctamente el dato de id")
        }
       
        if sqlite3_bind_text(stmt, 2, titleL.utf8String, -1, nil) != SQLITE_OK{
            print ("se cargo correctamente el dato de title")
        }
        if sqlite3_bind_int(stmt, 3, (vote_count as NSString).intValue) != SQLITE_OK{
            print ("se cargo correctamente el dato de vote_count")
        }
        
        if sqlite3_bind_text(stmt, 4, vote_averageL.utf8String, -1, nil) != SQLITE_OK{
            print ("se cargo correctamente el dato de vote_average")
        }
        
        if sqlite3_bind_text(stmt, 5, overviewL.utf8String, -1, nil) != SQLITE_OK{
            print ("se cargo correctamente el dato de overview")
        }
        
        if sqlite3_bind_text(stmt, 6, poster_pathL.utf8String, -1, nil) != SQLITE_OK{
            print ("se cargo correctamente el dato de posterPAth")
        }
        
        if sqlite3_bind_text(stmt, 7, backdrop_pathL.utf8String, -1, nil) != SQLITE_OK{
            print ("se cargo correctamente el dato de backdrop")
        }
        
        if sqlite3_bind_text(stmt, 8, release_dateL.utf8String, -1, nil) != SQLITE_OK{
            print ("se cargo correctamente el dato de release")
        }
        
        if sqlite3_bind_int(stmt, 9, (category as NSString).intValue) != SQLITE_OK{
            print ("se cargo correctamente el dato de categoria")
        }
      
        if sqlite3_step(stmt) == SQLITE_DONE{
            print ("se guardo correctamente la pelicula")
        }
        sqlite3_close(db)
    }
    
    
    

    
    
    
    
    
   
    
    //id , title , vote_count , vote_average , overview , poster_path , backdrop_path , release_date, category
   /* struct dats{
        var  id = 0
        var title = ""
        var vote_count = 0
        var vote_average = ""
        var overview = ""
        var poster_path = ""
        var backdrop_path = ""
        var release_date = ""
        var category = ""
    }*/
    
    func consultarXcategoria(id:Int) -> [datos] {
        var pelis : [datos] = []

        let selectQuery = "SELECT * FROM peliculas WHERE category = " + String(id)
        print (selectQuery)
        var queryStatement: OpaquePointer? = nil
        // var carrito : [datos] = []
        if sqlite3_prepare_v2(db, selectQuery , -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW ){
                //id , title , vote_count , vote_average , overview , poster_path , backdrop_path , release_date, category
                let id = sqlite3_column_int(queryStatement, 0)
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let vote_count = sqlite3_column_int(queryStatement, 2)
                let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
                let queryResultCol4 = sqlite3_column_text(queryStatement, 4)
                let queryResultCol5 = sqlite3_column_text(queryStatement, 5)
                let queryResultCol6 = sqlite3_column_text(queryStatement, 6)
                let queryResultCol7 = sqlite3_column_text(queryStatement, 7)
                let queryResultCol8 = sqlite3_column_text(queryStatement, 8)
                let title = String(cString: queryResultCol1!)
                let vote_average = String(cString: queryResultCol3!)
                let overview = String(cString: queryResultCol4!)
                let poster_path = String(cString: queryResultCol5!)
                let backdrop_path = String(cString: queryResultCol6!)
                let release_date = String(cString: queryResultCol7!)
                let category = String(cString: queryResultCol8!)
                
                
                pelis.append(datos(id : Int(id),title: title,vote_count: Int(vote_count),vote_average: vote_average,overview: overview,poster_path: poster_path,backdrop_path: backdrop_path,release_date: release_date,category: category ))
            }
        }
        else {
            print("No se pudo hacer la consulta del carrito de compras")
        }
        sqlite3_finalize(queryStatement)
        return pelis
    }
    
    
    func contarPelis () -> Int{
        var registros = 0
        let selectQuery = "SELECT * FROM peliculas"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, selectQuery , -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW ){
                registros=registros+1
            }
        }
        return registros
    }
    
    
    func consultarXid(id:Int) -> datos {
        var pelis : datos = datos()
        let selectQuery = "SELECT * FROM peliculas WHERE id = " + String(id)
        
        var queryStatement: OpaquePointer? = nil
        // var carrito : [datos] = []
        if sqlite3_prepare_v2(db, selectQuery , -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW ){
                //id , title , vote_count , vote_average , overview , poster_path , backdrop_path , release_date, category
                let id = sqlite3_column_int(queryStatement, 0)
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let vote_count = sqlite3_column_int(queryStatement, 2)
                let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
                let queryResultCol4 = sqlite3_column_text(queryStatement, 4)
                let queryResultCol5 = sqlite3_column_text(queryStatement, 5)
                let queryResultCol6 = sqlite3_column_text(queryStatement, 6)
                let queryResultCol7 = sqlite3_column_text(queryStatement, 7)
                let queryResultCol8 = sqlite3_column_text(queryStatement, 8)
                let title = String(cString: queryResultCol1!)
                let vote_average = String(cString: queryResultCol3!)
                let overview = String(cString: queryResultCol4!)
                let poster_path = String(cString: queryResultCol5!)
                let backdrop_path = String(cString: queryResultCol6!)
                let release_date = String(cString: queryResultCol7!)
                let category = String(cString: queryResultCol8!)
                
                pelis.id = Int(id)
                pelis.title = title
                pelis.vote_count = Int(vote_count)
                pelis.vote_average = vote_average
                pelis.overview = overview
                pelis.poster_path = poster_path
                pelis.backdrop_path = backdrop_path
                pelis.release_date = release_date
                pelis.category = category
            }
        }
        else {
            print("No se pudo hacer la consulta del carrito de compras")
        }
        sqlite3_finalize(queryStatement)
        return pelis
    }
    
    
    

    
    
    
}
