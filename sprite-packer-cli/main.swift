//
//  main.swift
//  sprite-packer
//
//  Created by James Randall on 21/12/2024.
//

import Foundation
import ArgumentParser

extension String {
    func toSizeOptions() -> SizeOptions? {
        let sizeParts = self.split(separator: "x")
        guard sizeParts.count == 2,
            let width = Int(sizeParts[0]),
            let height = Int(sizeParts[1])
        else { return nil }
        return SizeOptions(width: width, height: height)
    }
}

struct CLIOutputOptions  : ParsableArguments {
    @Option(name: .shortAndLong, help: "Output size in the format widthxheight. Defaults to 1024x768")
    var outputSize : String?
    
    @Option(name: .shortAndLong, help: "Image output path. Defaults to ./packed.png")
    var imagePath : String?
    
    @Option(name: .shortAndLong, help: "Image JSON output path. Defaults to ./packed.json")
    var jsonPath : String?
}

struct CLISvgOutputOptions : ParsableArguments {
    @Option(name: [.long, .customShort("f")], help: "If specified SVG images will be generated using the specified size (given in the format widthxheight)")
    var scaleToFit : String?
    
    @Option(name: .shortAndLong, help: "Root element fill colour to apply to SVG images (given in the format #RRGGBB)")
    var color : String?
}

struct CLI : ParsableCommand {
    @Option(name: .shortAndLong, help: "Source folder")
    var sourceFolder : String?
    
    @OptionGroup(title: "Output options")
    var outputOptions : CLIOutputOptions
    
    @OptionGroup(title: "SVG options")
    var svgOptions : CLISvgOutputOptions
    
    public static var configuration: CommandConfiguration {
        let samplePackerOptions = PackerOptions(
            output: OutputOptions(
                size: SizeOptions(width:1024, height:768),
                imagePath: "packed.png",
                jsonPath: "packed.json"
            ),
            svg: SvgOptions(
                scaleToFit: SizeOptions(width: 64, height: 64),
                fill: "#FF00CC"
            )
        )
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted]
        let jsonData = try? jsonEncoder.encode(samplePackerOptions)
        let jsonString = (jsonData != nil ? String(data: jsonData!, encoding: .utf8) : "") ?? ""
        
        return CommandConfiguration(
            discussion: "This tool will pack images into a single PNG file and generate a JSON index for that file. In addition to the options described here sprite packer will look for a file called sprite-packer.json in the source folder and merge the ones you specify into it. Sample json is shown below:\n\n\(jsonString)\n",
            version: "1.0.8")
    }
    
    func run() {
        let sourceFolder = sourceFolder ?? "."
        let optionsFile = sourceFolder + "/sprite-packer.json"
        var baseOptions =
            (try? JSONDecoder().decode(PackerOptions.self, from: Data(contentsOf: URL(fileURLWithPath: optionsFile)))) ?? PackerOptions.defaultOptions
        baseOptions.output.size = outputOptions.outputSize?.toSizeOptions() ?? baseOptions.output.size
        baseOptions.output.packIntoSingleFile = false
        baseOptions.output.imagePath = outputOptions.imagePath ?? baseOptions.output.imagePath ?? "packed.png"
        baseOptions.output.jsonPath = outputOptions.jsonPath ?? baseOptions.output.jsonPath ?? "packed.json"
        baseOptions.svg.scaleToFit = svgOptions.scaleToFit?.toSizeOptions() ?? baseOptions.svg.scaleToFit
        baseOptions.svg.fill = svgOptions.color ?? baseOptions.svg.fill
        
        processImages(sourceFolder: sourceFolder, options: baseOptions)
    }
}

CLI.main()
//CLI.main(["-s","/Users/jamesrandall/code/starship-tactics/ui-icons"])
//CLI.main(["--help"])


