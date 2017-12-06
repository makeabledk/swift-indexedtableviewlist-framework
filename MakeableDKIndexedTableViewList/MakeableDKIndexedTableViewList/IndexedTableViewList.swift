//
//  IndexedTableViewList.swift
//
//  Created by Andreas Dybdahl on 30/08/2017.
//  Copyright © 2017 Makeable. All rights reserved.
//

import Foundation

public class IndexedTableViewList<E> {
    
    fileprivate var sectionArray: [TableViewSection]
    
    public var numberOfSections: Int {
        return self.sectionArray.count
    }
    
    
    /// Initializes an IndexedTableViewList based on the specified parameters.
    ///
    /// - Parameters:
    ///   - list: the list/array of elements to index.
    ///   - compareStringProperty: the element property to compare by, this needs to be a String.
    ///   - headerElement: the element property to be used as the section header title. Supply this when you want a section header that is not the first letter of the compare property.
    ///   - sortOrder: the order to sort by: E.G ASCENDING/DESCENDING
    public convenience init(fromList list: [E], compareStringProperty: (_ object: E) -> String, headerElement: ((_ object: E) -> String)? = nil, sortOrder: ComparisonResult? = nil) {
        // Get indexedDict and call the init with that
        self.init(indexedDictionary: IndexedTableViewList.getIndexedTableViewList(fromList: list, compareStringProperty: compareStringProperty, headerElement: headerElement, sortOrder: sortOrder))
    }
    
    fileprivate init(indexedDictionary: [String: [E]]) {
        self.sectionArray = IndexedTableViewList.sectionArrayAccordingToHeaderOrder(indexedDict: indexedDictionary)
    }
    
    
    /// Initialized an empty IndexedTableViewList
    public init() {
        self.sectionArray = [TableViewSection]()
    }
    
    
    /// This method needs to be called if IndexedTableViewList is used within a tableview containing other cells that are not used by indexedTableViewList. Example: A statistics cell or a SearchBar etc.
    ///
    /// - Parameters:
    ///   - section: the section number for the section to be ignored by this class.
    ///   - elementsInSection: the number of elements in the section that is ignored.
    public func registerSectionForOtherUse(section: Int, elementsInSection: Int) {
        // Inserts a dummy section at the specified section index.
        let dummySection = TableViewSection(header: nil, elements: [Any](), elementCount: elementsInSection)
        self.sectionArray.insert(dummySection, at: section)
    }
    
    
    /// This methods needs to be called if a specific indexPath within the calling viewcontrollers tableview is to be ignored by IndexedTableViewList, Example: a SearchBar etc.
    ///
    /// - Parameter indexPath: the indexPath to be ignored.
    public func registerIndexPathForOtherUse(indexPath: IndexPath) {
        self.sectionArray[indexPath.section].elements.insert("", at: indexPath.row) // Inserts a nil object in the provided IndexPath. This maintains the indexPath for the other functions.
    }
    
    
    /// Call this method when the element at the specified indexPath is needed. Example: in didSelectRowForIndexPath.
    ///
    /// - Parameter indexPath: indexPath
    /// - Returns: the element at the specified indexPath, if any.
    public func elementFor(indexPath: IndexPath) -> E? {
        return self.sectionArray[indexPath.section].elements[indexPath.row] as? E
    }
    
    
    /// Call this method from the calling VC's numberOfRowsInSection.
    ///
    /// - Parameter section: section
    /// - Returns: the number of elements in the specified indexed section.
    public func rowsInSection(section: Int) -> Int {
        
        return self.sectionArray[section].elementCount
    }
    
    
    /// Call this method from the calling VC's titleForHeaderInSection
    ///
    /// - Parameter section: section where header title is needed.
    /// - Returns: the header title for the specified section
    public func titleForHeaderInSection(section: Int) -> String? {
        
        return self.sectionArray[section].header
    }
    
    
    /// Call this method when a section needs to be inserted before any other section.
    ///
    /// - Parameters:
    ///   - sectionHeader: the header title for the section to prepend.
    ///   - sectionElements: the elements contained in the section to prepend.
    public func prependSection(sectionHeader: String, sectionElements: [E]) {
        let section = TableViewSection(header: sectionHeader, elements: sectionElements)
        self.sectionArray.insert(section, at: 0)
    }
    
    
    // ----------------------------- Private Helper functions
    static fileprivate func sectionArrayAccordingToHeaderOrder(indexedDict: [String: [E]]) -> [TableViewSection] {
        var sectionArray = [TableViewSection]()
        
        // Go through the Section headers in ascending order, creating a TableViewSection for each.
        var keys: [String] = [String](indexedDict.keys)
        keys.sort { $0 < $1 }
        
        // Get elements corresponding to the section.
        for key in keys {
            if let sectionElements = indexedDict[key] {
                let section = TableViewSection(header: key, elements: sectionElements)
                
                // Add section to sectionList.
                sectionArray.append(section)
            }
        }
        
        return sectionArray
    }
    
    static fileprivate func getIndexedTableViewList(fromList list: [E], compareStringProperty: (_ object: E) -> String, headerElement: ((_ object: E) -> String)? = nil, sortOrder: ComparisonResult? = nil) -> [String: [E]] {
        
        // Create a set with all the needed headerElements, and sort them by the order corresponding to compareElement
        var headerSet = Set<String>()
        for element: E in list {
            
            if let headerElement = headerElement {
                headerSet.insert(headerElement(element).uppercased())
            } else {
                headerSet.insert(String(compareStringProperty(element).first!).uppercased())
            }
            
        }
        var headerArray: [String] = Array(headerSet)
        if let sortOrder = sortOrder {
            headerArray.sort { $0.compare($1) == sortOrder }
        } else {
            headerArray.sort { $0 < $1 }
        }
        
        // Create the indexed dictionary with the headerElements as keys, and all the corresponding objects in an array as the value
        var indexedDictionary = [String: [E]]()
        
        for header in headerArray {
            let headerElements = list.filter() { element in
                if let headerElement = headerElement {
                    
                    let h = headerElement(element).lowercased()
                    return h == header.lowercased()
                    
                } else {
                    
                    let h = String(compareStringProperty(element).first!).lowercased()
                    return h == header.lowercased()
                    
                }
            }
            indexedDictionary[header.uppercased()] = headerElements
        }
        
        return indexedDictionary
    }
    
}

// Represents a Section in a tableView, containing a list of elements belonging to the section, and the sectionTitle.
fileprivate struct TableViewSection {
    var header: String?
    var elements: [Any]
    var elementCount: Int
    
    init(header: String?, elements: [Any], elementCount: Int? = nil) {
        self.header = header
        self.elements = elements
        self.elementCount = elementCount == nil ? elements.count : elementCount!
    }
}
