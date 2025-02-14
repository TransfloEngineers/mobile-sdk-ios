class GetFileInfoFunction: ModuleFunction {
    private let module: FileSystemModule
    init(module: FileSystemModule) {
        self.module = module
        super.init(module: module, name: "getFileInfo")
    }
    override func handleJavascriptCall(argument: Any?, jsCallback: @escaping (Result<String, Error>) -> Void) {
        module.queue.async {
            
            guard let filePath = argument as? String else {
                jsCallback(Result.failure(GeotabDriveErrors.ModuleFunctionArgumentError))
                return
            }
            
            guard let drvfsDir = self.module.drvfsDir else {
                jsCallback(Result.failure(GeotabDriveErrors.FileException(error: FileSystemModule.DRVS_DOESNT_EXIST)))
                return
            }
            
            do {
                let result = try getFileInfo(fsPrefix: FileSystemModule.fsPrefix, drvfsDir: drvfsDir, path: filePath)
                jsCallback(Result.success(toJson(result)!))
            } catch {
                jsCallback(Result.failure(error))
            }
        }
    }
}
