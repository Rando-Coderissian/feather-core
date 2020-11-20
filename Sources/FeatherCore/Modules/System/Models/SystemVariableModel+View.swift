//
//  SystemVariableModel+View.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 10..
//

extension SystemVariableModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "key": key,
            "value": value,
            "hidden": hidden,
            "notes": notes,
        ])
    }
}
