//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

import Vapor

struct SystemResponseController {
    
    func handle(_ req: Request) async throws -> Response {
        guard req.feather.config.install.isCompleted else {
            let currentStep = req.feather.config.install.currentStep
            let steps: [SystemInstallStep] = req.invokeAllFlat(.installStep) + [.start, .finish]
            let orderedSteps = steps.sorted { $0.priority > $1.priority }.map(\.key)

            var hookArguments = HookArguments()
            hookArguments.nextInstallStep = SystemInstallStep.finish.key
            hookArguments.currentInstallStep = currentStep

            if let currentIndex = orderedSteps.firstIndex(of: currentStep) {
                let nextIndex = orderedSteps.index(after: currentIndex)
                if nextIndex < orderedSteps.count {
                    hookArguments.nextInstallStep = orderedSteps[nextIndex]
                }
            }
            let res: Response? = try await req.invokeAllFirstAsync(.installResponse, args: hookArguments)
            guard let res = res else {
                throw Abort(.internalServerError)
            }
            return res
        }

        let res: Response? = try await req.invokeAllFirstAsync(.response)
        guard let response = res else {
            if req.url.path == "/" {
                let template = SystemPageTemplate(.init(title: "Hello", message: "World"))
                return req.templates.renderHtml(template)
            }
            throw Abort(.notFound)
        }
        return response
    }
}
