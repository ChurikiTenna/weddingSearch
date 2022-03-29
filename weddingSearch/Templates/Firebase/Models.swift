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
struct RequestData: Codable {
    
    let userId: String
    let requestedAt: Timestamp
    var done = RequestState.requested.rawValue
    var estimatePDFPath: String?
    
    var reserveKibou: [Timestamp]?
    var reserveComment: String?
    var reserveDate: Timestamp?
    
    var venueInfo : VenueInfo?
    var basicInfo : BasicInfoData?
    var foodPrice : String?
    var drinkData : DrinkData?
    var kyoshiki : String?
    var flowerData : FlowerData?
    var otherFlowerData : OtherFlowerData?
    var itemData : ItemsData?
    var hikidemonoData : HikidemonoData?
    var photoData : PhotoData?
    var movieData : MovieData?
    var brideClothingData : BrideClothingData?
    var groomClothingData : GroomClothingData?
    var parentClothingData : ParentClothingData?
    var other : String?
    
    var _done: RequestState {
        return RequestState(rawValue: done) ?? .requested
    }
    
    init(userId: String,
         venueInfo: VenueInfo?,
         basicInfo: BasicInfoData?,
         foodPrice: String?,
         drinkData: DrinkData?,
         kyoshiki: String?,
         flowerData: FlowerData?,
         otherFlowerData: OtherFlowerData?,
         itemData: ItemsData?,
         hikidemonoData: HikidemonoData?,
         photoData: PhotoData?,
         movieData: MovieData?,
         brideClothingData: BrideClothingData?,
         groomClothingData: GroomClothingData?,
         parentClothingData: ParentClothingData?,
         other: String?) {
        
        self.userId = userId
        requestedAt = Ref.now
        
        self.venueInfo = venueInfo
        self.basicInfo = basicInfo
        self.foodPrice = foodPrice
        self.drinkData = drinkData
        self.kyoshiki = kyoshiki
        self.flowerData = flowerData
        self.otherFlowerData = otherFlowerData
        self.itemData = itemData
        self.hikidemonoData = hikidemonoData
        self.photoData = photoData
        self.movieData = movieData
        self.brideClothingData = brideClothingData
        self.groomClothingData = groomClothingData
        self.parentClothingData = parentClothingData
        self.other = other
    }
}
enum RequestState: String {
    case requested
    case estimated
    case reserveRequested
    case reserveCanceled // 希望の時間に予約できなかった
    case reserveDecided //　管理者が予約時間を決めた
   // case reserveChecked //　ユーザーが予約を確定した
}
