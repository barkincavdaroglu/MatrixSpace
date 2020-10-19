//
//  MatrixVM.swift
//  Matrix Calc
//
//  Created by Barkin Cavdaroglu on 9/2/20.
//

import Foundation
//import Linear_Algebra
import Accelerate


class MatrixVM: ObservableObject {
    //MARK: - Matrix Trackers/Variables
    @Published var matricesValues = [[[String]]]()
    @Published var dimensions = [[Int]]()
    
    //MARK: - Results
    @Published var determinant = ""
    @Published var eigenvals = [String]()
    @Published var eigenvectors = [[String]]()
    @Published var linEqSolver = [String]()
    @Published var resultingMatrix = [[String]]()
    @Published var rank = ""
    @Published var result = [String]()
    
    @Published var inverseComposition = [[String]]()
    
    //MARK: - State Trackers
    @Published var isMatrixFull = false
    
    @Published var savedNotebooks = [[[String]]]()
    @Published var keyboardTracker = [[[Bool]]]() // IMPORTANT
    
    @Published var copiedMatrix = [[String]]()
    
    @Published var SVD = [[[String]]]()
    @Published var LEQSResult = [[String]]()
    @Published var noMatrixView = true
    
    @Published var showResult = false
    @Published var operation = ""
    @Published var showOp = false
    
    var howManyValues = 0 // if no match then give the error here instead of in view
    var solutionVector = [Double]()
    var matricesForCalc = [Matrix]()
    var matricesConverted = false
    var isSymmetric = false
    
    @Published var matrixTypes = [MatrixType]()
    
    var dimensionIndex = 0
    
    init() {}
    
    func partialClear() {
        matricesConverted = false
        matricesForCalc = [Matrix]()
    }
    
    func composeInverse() {
        var matrix = matricesValues[0]
        let inverse = resultingMatrix
        for i in 0..<matrix.count {
            matrix[i].append(contentsOf: inverse[i])
        }
        self.inverseComposition = matrix
    }
    
    func revertInverseComposition(of matrix: [[String]]) -> [[String]] {
        var composite = matrix
        for i in 0..<matrix.count {
            composite[i].removeSubrange((matrix[i].count/2)..<composite[i].count)
        }
        return composite
    }
    
    func composeLEQSForNotebookView() {
        var matrix = matricesValues[0]
        let sol = solutionVector.map {String($0)}
        for i in 0..<matrix.count {
            matrix[i].append(sol[i])
        }
        self.LEQSResult = matrix
    }
    
    func revertLEQSComposition(of matrix: [[String]]) -> [[String]] {
        var compositeMatrix = matrix
        
        for i in 0..<compositeMatrix.count {
            compositeMatrix[i].remove(at: compositeMatrix[i].endIndex-1)
        }
        
        return (compositeMatrix)
    }
    
    
    func copyToWorkspace(operation: String) {
        if dimensionIndex == 0 && operation != "Linear Equations" && operation != "Invert" {
            dimensions.append([copiedMatrix.count, copiedMatrix[0].count])
            
            let arr = copiedMatrix.flatMap {$0}
            let matrix = Matrix(values: arr.map { __CLPK_doublereal($0)! }, row: dimensions[0][0], column: dimensions[0][1])
            
            if matrix.type == MatrixType.square {
                matrixTypes.append(MatrixType.square)
            }
            else if matrix.type == MatrixType.rectangular {
                matrixTypes.append(MatrixType.rectangular)
            }
            if matrix.type == MatrixType.symmetric {
                matrixTypes.append(MatrixType.symmetric)
            }
            noMatrixView = false
            isMatrixFull = true
            keyboardTracker.append([[Bool]](repeating: [Bool](repeating: true, count: copiedMatrix[0].count), count: copiedMatrix.count))
            self.matricesValues.append(copiedMatrix)
            showResult = false
            
        } else if dimensionIndex > 0 && operation != "Linear Equations" && operation != "Invert" {
            dimensions.append([copiedMatrix.count, copiedMatrix[0].count])
            let arr = copiedMatrix.flatMap {$0}
            let matrix = Matrix(values: arr.map {__CLPK_doublereal($0)! }, row: copiedMatrix.count, column: copiedMatrix[0].count)
            
            if matrix.type == MatrixType.square {
                matrixTypes.append(MatrixType.square)
            }
            else if matrix.type == MatrixType.rectangular {
                matrixTypes.append(MatrixType.rectangular)
            }
            if matrix.type == MatrixType.symmetric {
                matrixTypes.append(MatrixType.symmetric)
            }
            noMatrixView = false
            resultingMatrix = [[String]]()
            SVD = [[[String]]]()
            isMatrixFull = true
            keyboardTracker.append( [[Bool]](repeating: [Bool](repeating: true, count: dimensions[dimensionIndex][1]), count: dimensions[dimensionIndex][0]))
            dimensionIndex += 1
            matricesConverted = false
            self.matricesValues.append(copiedMatrix)
            showResult = false
        }
        
        else if operation == "Linear Equations" {
            let copiedMatrixLEQ = revertLEQSComposition(of: copiedMatrix)
            dimensions.append([copiedMatrixLEQ.count, copiedMatrixLEQ[0].count])
            
            let arr = copiedMatrixLEQ.flatMap {$0}
            let matrix = Matrix(values: arr.map { __CLPK_doublereal($0)! }, row: dimensions[0][0], column: dimensions[0][1])
            noMatrixView = false
            if matrix.type == MatrixType.square {
                matrixTypes.append(MatrixType.square)
            }
            else if matrix.type == MatrixType.rectangular {
                matrixTypes.append(MatrixType.rectangular)
            }
            if matrix.type == MatrixType.symmetric {
                matrixTypes.append(MatrixType.symmetric)
            }
            dimensionIndex += 1
            isMatrixFull = true
            
            keyboardTracker.append([[Bool]](repeating: [Bool](repeating: true, count: copiedMatrixLEQ[0].count), count: copiedMatrixLEQ.count))
            
            self.matricesValues.append(copiedMatrixLEQ)
            showResult = false
        }
        
        else if operation == "Invert" {
            let copiedMatrixLEQ = revertInverseComposition(of: copiedMatrix)
            dimensions.append([copiedMatrixLEQ.count, copiedMatrixLEQ[0].count])
            
            let arr = copiedMatrixLEQ.flatMap {$0}
            let matrix = Matrix(values: arr.map { __CLPK_doublereal($0)! }, row: dimensions[0][0], column: dimensions[0][1])
            noMatrixView = false
            if matrix.type == MatrixType.square {
                matrixTypes.append(MatrixType.square)
            }
            else if matrix.type == MatrixType.rectangular {
                matrixTypes.append(MatrixType.rectangular)
            }
            if matrix.type == MatrixType.symmetric {
                matrixTypes.append(MatrixType.symmetric)
            }
            dimensionIndex += 1
            isMatrixFull = true
            
            keyboardTracker.append([[Bool]](repeating: [Bool](repeating: true, count: copiedMatrixLEQ[0].count), count: copiedMatrixLEQ.count))
            
            self.matricesValues.append(copiedMatrixLEQ)
            showResult = false
        }
    }
    
    func clear() {
        showOp = false
        matricesValues = [[[String]]]()
        noMatrixView = true
        dimensions = [[Int]]()
        showResult = false
        
        determinant = ""
        eigenvals = [String]()
        eigenvectors = [[String]]()
        linEqSolver = [String]()
        resultingMatrix = [[String]]()
        rank = ""
        result = [String]()
        operation = ""
        
        isMatrixFull = false
        howManyValues = 0
        savedNotebooks = [[[String]]]()
        keyboardTracker = [[[Bool]]]()
        
        copiedMatrix = [[String]]()
        
        SVD = [[[String]]]()
        
        solutionVector = [Double]()
        matricesForCalc = [Matrix]()
        matricesConverted = false
        isSymmetric = false
        
        matrixTypes = [MatrixType]()
        
        dimensionIndex = 0
    }
    
    func deleteMatrix(idx: Int) {
        if dimensions.count == 1 || matricesValues.count == 1{
            clear()
        } else if dimensions.count > 1 {
            matricesValues.remove(at: idx)
            dimensions.remove(at: idx)
            keyboardTracker.remove(at: idx)
            
            if dimensionIndex == matricesValues.count + 1 {
                dimensionIndex -= 1
            }
            
            if matricesConverted {
                matricesForCalc.remove(at: matricesForCalc.endIndex - 1)
                matrixTypes.remove(at: idx)
            }
            showResult = false
            showOp = false
        }
    }
    
    func setDimensions(row: Int, column: Int) throws {
        if row <= 10 && column <= 10 {
            if dimensionIndex != 0 {
                dimensions.append([row, column])
                keyboardTracker.append([[Bool]](repeating: [Bool](repeating: true, count: column), count: row))
                self.matricesValues.append([[String]](repeating: [String](repeating: "", count: column), count: row))
                matricesConverted = false
                self.matricesForCalc = [Matrix]()
                showResult = false
            } else {
                
                dimensions.append([row, column])
                matricesConverted = false
                keyboardTracker.append([[Bool]](repeating: [Bool](repeating: true, count: column), count: row))
                self.matricesValues.append([[String]](repeating: [String](repeating: "", count: column), count: row))
                self.matricesForCalc = [Matrix]()
                noMatrixView = false
                showResult = false
            }
            self.dimensionIndex += 1
        } else {
            throw WorkspaceError.MatrixTooLarge
        }
    }
    
    func solVector() throws {
        if isMatrixFull {
            if matricesValues[1].count == matricesValues[0].count && matricesValues[1][0].count == 1 {
                if !matricesConverted {
                    try convert3DMatrix()
                }
                if matricesForCalc[1].row == matricesForCalc[0].row && matricesForCalc[1].column == 1 {
                    let vectt = matricesValues[1].flatMap { $0 }
                    solutionVector = vectt.map { Double($0)! }
                }
                showResult = false
            }
            else {
                throw WorkspaceError.LinearSystemOfEquationsIncorrectInput
            }
        }
    }
    
    func convert3DMatrix() throws {
        if matricesConverted == false {
            var operatable = true
            for matrixIndex in 0..<matricesValues.count {
                for i in 0..<matricesValues[matrixIndex].count {
                    for j in 0..<matricesValues[matrixIndex][i].count {
                        if Double(matricesValues[matrixIndex][i][j]) == nil {
                            operatable = false
                        }
                    }
                }
            }
            if operatable {
                for i in 0..<matricesValues.count {
                    let arr = matricesValues[i].flatMap { $0}
                    let matrix = Matrix(values: arr.map { __CLPK_doublereal($0)! }, row: dimensions[i][0], column: dimensions[i][1])
                    if matrix.type == MatrixType.square {
                        matrixTypes.append(MatrixType.square)
                    }
                    else if matrix.type == MatrixType.rectangular {
                        matrixTypes.append(MatrixType.rectangular)
                    }
                    if matrix.type == MatrixType.symmetric {
                        matrixTypes.append(MatrixType.symmetric)
                    }
                    self.matricesForCalc.append(matrix)
                }
                matricesConverted = true
            } else {
                throw MatrixError.matrixNotFull
            }
        }
    }
    
    func addValueToMatrix(row: Int, column: Int, value: String, idx: Int) {
        matricesValues[idx][row][column] = value
        howManyValues += 1
        if Double(value) == nil {
            keyboardTracker[idx][row][column] = false
        }
        else {
            keyboardTracker[idx][row][column] = true
        }
        if howManyValues == matricesValues.count * matricesValues[0].count * matricesValues[0][0].count {
            isMatrixFull = true
        }
    }
    
    
    func multiply() throws {
        partialClear()
        if isMatrixFull && matricesValues.count >= 2 {
                do {
                    try convert3DMatrix()
                } catch {
                    throw error
                }
            
            do {
                var multiplied = matricesForCalc[0]
                var result = [[String]]()
                for i in 1..<matricesForCalc.count {
                    multiplied = try multiplied * matricesForCalc[i]
                    let (m, n) = multiplied.dim()
                    result = [[String]](repeating: [String](repeating: "", count: n), count: m)
                    for i in 0..<m {
                        result[i] = multiplied[i, nil].map { String(String($0).prefix(5))}
                    }
                }
                self.resultingMatrix = result
                showResult = true
                operation = "Multiplication"
                showOp = false
            } catch {
                throw error
            }
        }
        
    }
    
    func getEigenvalues() throws {
        partialClear()
        if isMatrixFull {
            //if !matricesConverted {
                do {
                    try convert3DMatrix()
                } catch {
                    throw error
                }
            //}
            if matricesConverted {
                do {
                    let copy: Matrix = matricesForCalc[0]
                    try eig(copy)
                    showResult = false
                    operation = "Eigenvalues"
                    showOp = true
                } catch {
                    throw error
                }
            }
        }
        
    }
    
    func getDeterminant() throws  {
        partialClear()
        
        if isMatrixFull {
            //if !matricesConverted {
                do {
                    try convert3DMatrix()
                } catch {
                    throw error
                }
            //}
            if matrixTypes[0] == MatrixType.square {
                
                do {
                    determinant = try String(matricesForCalc[0].findDeterminantLUP() * -1)
                    self.result = [determinant]
                    showResult = false
                    operation = "Determinant"
                    showOp = true
                } catch {
                    throw error
                }
            }
            else {
                throw InputMatrixError.notSquare
            }
            
            
        }
    }
    
    
    
    func invertSelf() throws {
        partialClear()
        if isMatrixFull {
            do {
                try convert3DMatrix()
            } catch {
                throw error
            }
            if matrixTypes[0] == MatrixType.square {
                
                //if !matricesConverted {
                    do {
                        try convert3DMatrix()
                    } catch {
                        throw error
                    }
                //}
                do {
                    let copy = try self.matricesForCalc[0].LUPInvert()
                    let (m, n) = copy.dim()
                    var result = [[String]](repeating: [String](repeating: "", count: m), count: n)
                    for i in 0..<m{
                        for j in 0..<n {
                            result[i][j] = String(String(copy[i, j]).prefix(5))
                        }
                    }
                    
                    self.resultingMatrix = result
                    showResult = true
                    operation = "Invert"
                    showOp = true
                } catch {
                    throw error
                }
                
            }
            else {
                throw InputMatrixError.notSquare
            }
        }
    }
    
    func diagonalizeSelf() throws {
        partialClear()
        if isMatrixFull {
            //if !matricesConverted {
                do {
                    try convert3DMatrix()
                } catch {
                    throw error
                }
            //}
            if matricesConverted {
                do {
                    let copy: Matrix = matricesForCalc[0]
                    try eig(copy)
                    showResult = true
                    showOp = false
                    operation = "Diagonalization"
                } catch {
                    throw error
                }
            }
        }
    }
    
    func solveLEQ() throws {
        if isMatrixFull {
            if matrixTypes[0] == MatrixType.square {
                    if !matricesConverted {
                        do {
                            try convert3DMatrix()
                        } catch {
                            throw error
                        }
                    }
                    do {
                        if isSymmetric {
                            linEqSolver = try matricesForCalc[0].solveByCholesky(b: solutionVector).map { String($0) }
                            self.result = linEqSolver
                            showResult = false
                            operation = "Linear Equations"
                        } else {
                            linEqSolver = try matricesForCalc[0].LUP_Solve(solutionVector: solutionVector).map { String($0) }
                            self.result = linEqSolver
                            showResult = false
                            operation = "Linear Equations"
                            showOp = true
                        }
                    } catch {
                        throw error
                    }
                
            }
            else {
                throw InputMatrixError.notSquare
            }
        }
    }
    
    func matrixExp(of: String) throws {
        if isMatrixFull {
            if !matricesConverted {
                do {
                    try convert3DMatrix()
                } catch {
                    throw error
                }
            }
            if matrixTypes[0] == MatrixType.square {
                
                do {
                    self.resultingMatrix = [[String]]()
                    let copy: Matrix = try self.matricesForCalc[0].MatrixExponent(of: Int(of) ?? 1)
                    let m = copy.row
                    
                    for i in 0..<m{
                        resultingMatrix.append((copy[i, nil].map { String(String(format: "%.1f", $0)) }))
                    }
                    showResult = true
                    operation = "Exp"
                    showOp = false
                } catch {
                    throw error
                }
            } else {
                throw InputMatrixError.notSquare
            }
        }
        
    }
    
    
    
    public func shapeDiagonal(matrix: [__CLPK_doublereal], row: Int, column: Int) -> [[String]] {
        var result = [[String]](repeating: [String](repeating: "0", count: column), count: row)
        
        for i in 0..<matrix.count {
            result[i][i] = String(String(matrix[i]).prefix(5))
        }
        
        return result
        
    }
    
    public func shapeDiagonal(matrix: [String], row: Int, column: Int) -> [[String]] {
        var result = [[String]](repeating: [String](repeating: "0", count: column), count: row)
        
        for i in 0..<matrix.count {
            result[i][i] = matrix[i]
        }
        
        return result
        
    }
    
    // https://software.intel.com/sites/products/documentation/doclib/mkl_sa/11/mkl_lapack_examples/dgeev_ex.c.htm
    func eig(_ A: Matrix) throws  {
        if matrixTypes[0] == MatrixType.square {
            var a = A.getAllColumns()
            var N = __CLPK_integer(A.row)
            var LDA = N
            
            var wkOpt = __CLPK_doublereal(0.0)
            var lWork = __CLPK_integer(-1)
            
            var jobvl: Int8 = 86
            var jobvr: Int8 = 86
            
            var info = __CLPK_integer(0)
            
            var wr = [Double](repeating: 0.0, count: Int(N))
            var wi = [Double](repeating: 0.0, count: Int(N))
            var vl = [__CLPK_doublereal](repeating: 0.0, count: Int(N * N))
            var vr = [__CLPK_doublereal](repeating: 0.0, count: Int(N * N))
            
            var ldvl = N
            var ldvr = N
            
            dgeev_(&jobvl, &jobvr, &N, &a.matrix, &LDA, &wr, &wi, &vl, &ldvl, &vr, &ldvr, &wkOpt, &lWork, &info)
            
            lWork = __CLPK_integer(wkOpt)
            var work = [Double](repeating: 0.0, count: Int(lWork))
            
            dgeev_(&jobvl, &jobvr, &N, &a.matrix, &LDA, &wr, &wi, &vl, &ldvl, &vr, &ldvr, &work, &lWork, &info)
            
            var eigenRight = [[String]](repeating: [String](repeating: "", count: A.column), count: A.row)
            
            // Converting eigenvector matrix to correct format for view
            for i in 0..<Int(N) {
                var j = 0
                while j < Int(N) {
                    if wi[j] == 0.0 {
                        eigenRight[j][i] = String(format: "%.3f", vr[i + j * Int(ldvr)])
                        j += 1
                    } else {
                        let complex = String(format: "%.3f", vr[i + (j + 1) * Int(ldvr)])
                        
                        if vr[i + (j + 1) * Int(ldvr)] < 0 {
                            eigenRight[j][i] = "\(String(format: "%.3f", vr[i + j * Int(ldvr)])) \(complex)i"
                        } else {
                            eigenRight[j][i] = "\(String(format: "%.3f", vr[i + j * Int(ldvr)])) + \(complex)i"
                        }
                        
                        if (vr[i + (j + 1) * Int(ldvr)] * -1) < 0 {
                            eigenRight[j+1][i] = "\(String(format: "%.3f", vr[i + j * Int(ldvr)])) - \(String(format: "%.3f", abs(vr[i + (j + 1) * Int(ldvr)] * -1)))i"
                        } else {
                            eigenRight[j+1][i] = "\(String(format: "%.3f", vr[i + j * Int(ldvr)])) + \(String(format: "%.3f", abs(vr[i + (j + 1) * Int(ldvr)] * -1)))i"
                        }
                        j += 2
                    }
                }
            }
            
            
            var resultTemporary = [String]()
            for each in 0..<wr.count {
                if wi[each] != 0 {
                    if wi[each] <= 0 {
                        let imaginary = String(format: "%.2f", wi[each]).replacingOccurrences(of: "-", with: "")
                        resultTemporary.append("\(String(format: "%.2f", wr[each]) + "-" + imaginary + "i")")
                    } else {
                        resultTemporary.append("\(String(format: "%.2f", wr[each]) + "+" + String(format: "%.2f", wi[each]) + "i")")
                    }
                }
                else {
                    resultTemporary.append("\(String(format: "%.2f", wr[each]))")
                }
            }
            self.resultingMatrix = [[String]]()
            self.resultingMatrix = shapeDiagonal(matrix: resultTemporary, row: A.row, column: A.column)
            
            self.result = resultTemporary
            self.eigenvals = result
            self.eigenvectors = eigenRight
            
            if info > 0 {
                throw ResultError.failedToCompleteEigens
            }
        }
        else {
            throw InputMatrixError.notSquare
        }
    }
    
    
    func svd() throws  {
        if isMatrixFull {
            if !matricesConverted {
                do {
                    try convert3DMatrix()
                } catch {
                    throw error
                }
            }
            
            var _A = matricesForCalc[0].getAllColumns()
            var jobz: Int8 = 65 // 'A'
            
            var M = __CLPK_integer(matricesForCalc[0].row);
            var N = __CLPK_integer(matricesForCalc[0].column);
            
            var LDA = M;
            var LDU = M;
            var LDVT = N;
            
            var wkOpt = __CLPK_doublereal(0.0)
            var lWork = __CLPK_integer(-1)
            var iWork = [__CLPK_integer](repeating: 0, count: Int(8 * min(M, N)))
            
            var info = __CLPK_integer(0)
            
            var s = [Double](repeating: 0.0, count: Int(min(M, N))) 
            var U = [__CLPK_doublereal](repeating: 0.0, count: Int(LDU)*Int(M))
            var VT = [__CLPK_doublereal](repeating: 0.0, count: Int(LDVT)*Int(N))
            
            dgesdd_(&jobz, &M, &N, &_A.matrix, &LDA, &s, &U, &LDU, &VT, &LDVT, &wkOpt, &lWork, &iWork, &info)
            
            lWork = __CLPK_integer(wkOpt)
            var work = [Double](repeating: 0.0, count: Int(lWork))
            
            dgesdd_(&jobz, &M, &N, &_A.matrix, &LDA, &s, &U, &LDU, &VT, &LDVT, &work, &lWork, &iWork, &info)
            
            if info > 0 {
                throw ResultError.failedToCompleteSVD
            }
            
            
            self.rank = String(s.count)
            
            self.SVD.append(Transpose(matrix: U, row: matricesForCalc[0].row, column: matricesForCalc[0].row))
            self.SVD.append(shapeDiagonal(matrix: s, row: matricesForCalc[0].row, column: matricesForCalc[0].column))
            self.SVD.append(Transpose(matrix: VT, row: matricesForCalc[0].column, column: matricesForCalc[0].column))
            showResult = true
            operation = "SVD"
            showOp = true
        }
    }
    
    func Transpose(matrix: [__CLPK_doublereal], row: Int, column: Int) -> [[String]] {
        var some = [[__CLPK_doublereal]]()
        for i in 0..<column {
            some.append(Array(matrix[i*row..<(i*row)+row]))
        }
        
        var result = [[String]](repeating: [String](repeating: "0", count: column), count: row)
        for i in 0..<row {
            for j in 0..<column {
                result[i][j] = String(String(some[j][i]).prefix(5))
            }
        }
        
        return result
    }
    
    func Transpose(matrix: [__CLPK_doublereal], row: Int, column: Int) -> [__CLPK_doublereal] {
        var some = [[__CLPK_doublereal]]()
        
        for i in 0..<column {
            some.append(Array(matrix[i*row..<(i*row)+row]))
        }
        
        var result = [[__CLPK_doublereal]](repeating: [__CLPK_doublereal](repeating: 0, count: column), count: row)
        for i in 0..<row {
            for j in 0..<column {
                result[i][j] = some[j][i]
            }
        }
        
        return result.flatMap {$0}
    }
}



extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
