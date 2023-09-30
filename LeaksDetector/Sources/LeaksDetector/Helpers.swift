//
//  File.swift
//  
//
//  Created by Hoang Anh Tuan on 30/09/2023.
//

import Foundation
import TSCBasic
import TSCUtility

let terminalController = TerminalController(stream: stdoutStream)

func log(
    message: @autoclosure () -> String,
    color: TerminalController.Color = .noColor,
    needEndline: Bool = true,
    isBold: Bool = false
) {
#if DEBUG
    debugPrint(message())
#else
    terminalController?.write(message(), inColor: color, bold: isBold)
    
    if needEndline {
        terminalController?.endLine()
    }
#endif
}
