//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

import SwiftHtml

struct SystemFileUploadTemplate: TemplateRepresentable {
    
    var context: SystemFileUploadContext
    
    init(_ context: SystemFileUploadContext) {
        self.context = context
    }
    
    func currentKey(_ req: Request) -> String {
        if let key = try? req.query.get(String.self, at: "key") {
            return key
        }
        return ""
    }
    
    @TagBuilder
    func render(_ req: Request) -> Tag {
        SystemIndexTemplate(.init(title: "Upload files")) { //}, breadcrumbs: [
//            LinkContext(label: "System", dropLast: 2),
//            LinkContext(label: "Files", dropLast: 1),
//        ])) {
            Wrapper {
                Container {
                    LeadTemplate(.init(title: "Upload files")).render(req)
                    FormTemplate(context.form).render(req)
                }
            }
        }
        .render(req)
    }
}


