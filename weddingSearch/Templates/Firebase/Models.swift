//
//  Models.swift
//  QuizMaker
//
//  Created by 中力天和 on 2022/01/18.
//

import FirebaseFirestoreSwift
import FirebaseFirestore

struct User: Codable {
    
    var nameKanji = ""
    var surnameKanji = ""
    
    var nameKana = ""
    var surnameKana = ""
    
    var birthDate: Timestamp!
    var gender = ""
}
