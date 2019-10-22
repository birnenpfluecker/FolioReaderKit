//
//  BookStorage.swift
//  FolioReaderKit
//
//  Created by xuchao on 2019/10/21.
//

import Foundation
import SQLite

public final class BookStorage {
    
    public static let instance = BookStorage()
    
    public let dbPath: String
    public let connect: Connection
    let highlightTable: HighlightTableMetadata
    
    init?() {
        var rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        dbPath = rootPath.appending("/books.db")
        do {
            connect = try Connection(dbPath)
#if DEBUG
            print("Database path: \(dbPath)")
            connect.trace { (sql) in
                print("Execute sql: \(sql)")
            }
#endif
            highlightTable = HighlightTableMetadata()
            try highlightTable.create(connect)
        } catch {
            printLog(error)
            return nil
        }
    }
}

extension BookStorage {
    
    func save(withHighlight object: Highlight) throws {
        let setters = [highlightTable.bookId <- object.bookId, highlightTable.content <- object.content, highlightTable.contentPost <- object.contentPost, highlightTable.contentPre <- object.contentPre, highlightTable.date <- object.date, highlightTable.highlightId <- object.highlightId, highlightTable.page <- object.page, highlightTable.type <- object.type, highlightTable.startOffset <- object.startOffset, highlightTable.endOffset <- object.endOffset, highlightTable.noteForHighlight <- object.noteForHighlight]
        try connect.run(highlightTable.table.insert(setters))
    }
    
    func remove(withHighlightId highlightId: String) throws {
        try connect.run(highlightTable.table.filter(highlightTable.highlightId == highlightId).delete())
    }
    
    func remove(withBookId bookId: String) throws {
        try connect.run(highlightTable.table.filter(highlightTable.bookId == bookId).delete())
    }
    
    func updateType(withHighlightId highlightId: String, type: Int) throws {
        try connect.run(highlightTable.table.filter(highlightTable.highlightId == highlightId).update(highlightTable.type <- type))
    }
    
    func updateNote(withHighlightId highlightId: String, note: String) throws {
        try connect.run(highlightTable.table.filter(highlightTable.highlightId == highlightId).update(highlightTable.noteForHighlight <- note))
    }
    
    func query(withHighlightId highlightId: String) throws -> Highlight? {
        guard let row = try connect.pluck(highlightTable.table.filter(highlightTable.highlightId == highlightId)) else { return nil }
        return toHighlight(row)
    }
    
    func query(withBookId bookId: String, page: Int?) throws -> [Highlight] {
        let query: QueryType
        if let p = page {
            query = highlightTable.table.filter(highlightTable.bookId == bookId && highlightTable.page == p)
        } else {
            query = highlightTable.table.filter(highlightTable.bookId == bookId)
        }
        let rows = try connect.prepare(query)
        return rows.compactMap({ toHighlight($0) })
    }
    
    func queryAll() throws -> [Highlight] {
        let rows = try connect.prepare(highlightTable.table)
        return rows.compactMap({ toHighlight($0) })
    }
    
    private func toHighlight(_ row: Row) -> Highlight? {
        do {
            var h = Highlight()
            h.bookId = try row.get(highlightTable.bookId)
            h.content = try row.get(highlightTable.content)
            h.contentPost = try row.get(highlightTable.contentPost)
            h.contentPre = try row.get(highlightTable.contentPre)
            h.date = try row.get(highlightTable.date)
            h.highlightId = try row.get(highlightTable.highlightId)
            h.page = try row.get(highlightTable.page)
            h.type = try row.get(highlightTable.type)
            h.startOffset = try row.get(highlightTable.startOffset)
            h.endOffset = try row.get(highlightTable.endOffset)
            h.noteForHighlight = try row.get(highlightTable.noteForHighlight)
            return h
        } catch {
            printLog(error)
        }
        return nil
    }
}
