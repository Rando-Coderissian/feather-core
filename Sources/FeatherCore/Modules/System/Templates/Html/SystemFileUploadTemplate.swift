//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

import Vapor
import SwiftHtml

final class SystemFileUploadTemplate: AbstractTemplate<SystemFileUploadContext> {
    
    override func render(_ req: Request) -> Tag {
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

