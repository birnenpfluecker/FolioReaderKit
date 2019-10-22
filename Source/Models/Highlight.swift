//
//  Highlight.swift
//  FolioReaderKit
//
//  Created by Heberti Almeida on 11/08/15.
//  Copyright (c) 2015 Folio Reader. All rights reserved.
//

import Foundation
import SQLite

/// A Highlight object
open class Highlight {
    open var bookId: String!
    open var content: String!
    open var contentPost: String!
    open var contentPre: String!
    open var date: Date!
    open var highlightId: String!
    open var page: Int = 0
    open var type: Int = 0
    open var startOffset: Int = -1
    open var endOffset: Int = -1
    open var noteForHighlight: String?
}

struct HighlightTableMetadata {
    
    let table = Table("book_highlight")
    let bookId = Expression<String>("book_id")
    let content = Expression<String>("content")
    let contentPost = Expression<String>("content_post")
    let contentPre = Expression<String>("content_pre")
    let date = Expression<Date>("date")
    let highlightId = Expression<String>("highlight_id")
    let page = Expression<Int>("page")
    let type = Expression<Int>("type")
    let startOffset = Expression<Int>("start_offset")
    let endOffset = Expression<Int>("end_offset")
    let noteForHighlight = Expression<String?>("note_for_highlight")
    
    func create(_ connection: Connection) throws {
        try connection.run(table.create(ifNotExists: true, block: { (builder) in
            builder.column(self.bookId)
            builder.column(self.content)
            builder.column(self.contentPost)
            builder.column(self.contentPre)
            builder.column(self.date, defaultValue: Date())
            builder.column(self.highlightId, primaryKey: true)
            builder.column(self.page, defaultValue: 0)
            builder.column(self.type, defaultValue: 0)
            builder.column(self.startOffset, defaultValue: -1)
            builder.column(self.endOffset, defaultValue: -1)
            builder.column(self.noteForHighlight)
        }))
    }
}
