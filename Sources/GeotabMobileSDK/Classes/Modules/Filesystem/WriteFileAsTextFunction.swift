import Foundation

struct WriteFileAsTextArgument: Codable {
    let path: String // drvfs://sdsd/sdsd/fdd.txt
    let data: String // text data
    let offset: UInt64? // offset is in Z+, not considering negative offset for now.
}

class WriteFileAsTextFunction: ModuleFunction {
    private let module: FileSystemModule
    init(module: FileSystemModule) {
        self.module = module
        super.init(module: module, name: "writeFileAsText")
    }
    
    override func handleJavascriptCall(argument: Any?, jsCallback: @escaping (Result<String, Error>) -> Void) {
        module.queue.async {
            guard argument != nil, JSONSerialization.isValidJSONObject(argument!), let argData = try? JSONSerialization.data(withJSONObject: argument!) else {
                jsCallback(Result.failure(GeotabDriveErrors.ModuleFunctionArgumentError))
                return
            }
            guard let arg = try? JSONDecoder().decode(WriteFileAsTextArgument.self, from: argData) else {
                jsCallback(Result.failure(GeotabDriveErrors.ModuleFunctionArgumentError))
                return
            }
            let path = arg.path
            
            guard let data = arg.data.data(using: .utf8) else {
                jsCallback(Result.failure(GeotabDriveErrors.ModuleFunctionArgumentError))
                return
            }
            
            guard let drvfsDir = self.module.drvfsDir else {
                jsCallback(Result.failure(GeotabDriveErrors.FileException(error: FileSystemModule.DRVS_DOESNT_EXIST)))
                return
            }
            
            do {
                let size = try writeFile(fsPrefix: FileSystemModule.fsPrefix, drvfsDir: drvfsDir, path: path, data: data, offset: arg.offset)
                jsCallback(Result.success("\(size)"))
            } catch {
                jsCallback(Result.failure(error))
                return
            }
            
        }
    }
}
