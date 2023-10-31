//
//  AllCategoriesResponse.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 30/10/2023.
//

import Foundation
/*
 
 categories =     {
     href = "https://api.spotify.com/v1/browse/categories?country=EG&offset=0&limit=2";
     items =         (
                     {
             href = "https://api.spotify.com/v1/browse/categories/toplists";
             icons =                 (
                                     {
                     height = 275;
                     url = "https://t.scdn.co/media/derived/toplists_11160599e6a04ac5d6f2757f5511778f_0_0_275_275.jpg";
                     width = 275;
                 }
             );
             id = toplists;
             name = "\U0623\U0646\U062c\U062d \U0642\U0648\U0627\U0626\U0645 \U0627\U0644\U0623\U063a\U0627\U0646\U064a";
         },
                     
     );
     limit = 2;
     next = "https://api.spotify.com/v1/browse/categories?country=EG&offset=2&limit=2";
     offset = 0;
     previous = "<null>";
     total = 41;
 };
}

 */
struct AllCategoriesResponse: Codable {
    let categories: CategoriesResponse
}

struct CategoriesResponse: Codable {
    let items: [Category]
}

struct Category: Codable {
    let icons: [APIImage]
    let id: String
    let name: String
}
