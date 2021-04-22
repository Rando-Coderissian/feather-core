//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 21..
//

final class UserModule: FeatherModule {

    static var moduleKey: String = "user"

    var bundleUrl: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Bundle")
    }

    func boot(_ app: Application) throws {
        /// database
        app.databases.middleware.use(UserAccountModelSafeEmailMiddleware())
        
        app.migrations.add(UserMigration_v1())
        /// middlewares
        app.middleware.use(UserTemplateScopeMiddleware())

        /// install
        app.hooks.register(.installModels, use: installModelsHook)
        app.hooks.register(.installPermissions, use: installPermissionsHook)
        
        /// acl
        app.hooks.register(.permission, use: permissionHook)
        app.hooks.register(.access, use: accessHook)
        
        app.hooks.register(.adminMiddlewares, use: adminMiddlewaresHook)
        app.hooks.register(.apiMiddlewares, use: apiMiddlewaresHook)
        

        /// admin menus
        app.hooks.register(.adminMenu, use: adminMenuHook)
        /// routes
        let router = UserRouter()
        try router.boot(routes: app.routes)
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.apiRoutes, use: router.apiRoutesHook)
        app.hooks.register(.apiAdminRoutes, use: router.apiAdminRoutesHook)
        
    }
  
    // MARK: - hooks
    

    #warning("add back permissions")
    func adminMenuHook(args: HookArguments) -> FrontendMenu {
        .init(key: "user",
              link: .init(label: "User",
                          url: "/admin/user/",
                          icon: "user",
                          permission: nil),
              items: [
                .init(label: "Accounts",
                      url: "/admin/user/accounts/",
                      permission: nil),
                .init(label: "Permissions",
                      url: "/admin/user/permissions/",
                      permission: nil),
                .init(label: "Roles",
                      url: "/admin/user/roles/",
                      permission: nil),
              ])
    }

    func permissionHook(args: HookArguments) -> Bool {
        let permission = args.permission
        
        guard let user = args.req.auth.get(User.self) else {
            return false
        }
        if user.isRoot {
            return true
        }
        return user.permissions.contains(permission)
    }
    
    /// by default return the permission as an access...
    func accessHook(args: HookArguments) -> EventLoopFuture<Bool> {
        args.req.eventLoop.future(permissionHook(args: args))
    }
    
    func adminMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            UserAccountSessionAuthenticator(),
            User.redirectMiddleware(path: "/login/?redirect=/admin/"),
        ]
    }

    #warning("Session auth is only for testing purposes!")
    func apiMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            UserAccountSessionAuthenticator(),
            UserTokenModel.authenticator(),
            User.guardMiddleware(),
        ]
    }
}
