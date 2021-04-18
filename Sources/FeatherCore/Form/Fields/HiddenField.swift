//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

class HiddenField: FormField<String, HiddenFieldView> {

    convenience init(key: String) {
        self.init(key: key, input: "", output: HiddenFieldView(key: key))
    }
    
    override func process(req: Request) throws {
        try super.process(req: req)
        output.value = input
    }
}
