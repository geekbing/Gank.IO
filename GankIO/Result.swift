//
//	Result.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Result : NSObject, NSCoding{

	var id : String!
	var createdAt : String!
	var desc : String!
	var publishedAt : String!
	var source : String!
	var type : String!
	var url : String!
	var used : Bool!
	var who : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		id = dictionary["_id"] as? String
		createdAt = dictionary["createdAt"] as? String
		desc = dictionary["desc"] as? String
		publishedAt = dictionary["publishedAt"] as? String
		source = dictionary["source"] as? String
		type = dictionary["type"] as? String
		url = dictionary["url"] as? String
		used = dictionary["used"] as? Bool
		who = dictionary["who"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if id != nil{
			dictionary["_id"] = id
		}
		if createdAt != nil{
			dictionary["createdAt"] = createdAt
		}
		if desc != nil{
			dictionary["desc"] = desc
		}
		if publishedAt != nil{
			dictionary["publishedAt"] = publishedAt
		}
		if source != nil{
			dictionary["source"] = source
		}
		if type != nil{
			dictionary["type"] = type
		}
		if url != nil{
			dictionary["url"] = url
		}
		if used != nil{
			dictionary["used"] = used
		}
		if who != nil{
			dictionary["who"] = who
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObjectForKey("_id") as? String
         createdAt = aDecoder.decodeObjectForKey("createdAt") as? String
         desc = aDecoder.decodeObjectForKey("desc") as? String
         publishedAt = aDecoder.decodeObjectForKey("publishedAt") as? String
         source = aDecoder.decodeObjectForKey("source") as? String
         type = aDecoder.decodeObjectForKey("type") as? String
         url = aDecoder.decodeObjectForKey("url") as? String
         used = aDecoder.decodeObjectForKey("used") as? Bool
         who = aDecoder.decodeObjectForKey("who") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encodeObject(id, forKey: "_id")
		}
		if createdAt != nil{
			aCoder.encodeObject(createdAt, forKey: "createdAt")
		}
		if desc != nil{
			aCoder.encodeObject(desc, forKey: "desc")
		}
		if publishedAt != nil{
			aCoder.encodeObject(publishedAt, forKey: "publishedAt")
		}
		if source != nil{
			aCoder.encodeObject(source, forKey: "source")
		}
		if type != nil{
			aCoder.encodeObject(type, forKey: "type")
		}
		if url != nil{
			aCoder.encodeObject(url, forKey: "url")
		}
		if used != nil{
			aCoder.encodeObject(used, forKey: "used")
		}
		if who != nil{
			aCoder.encodeObject(who, forKey: "who")
		}

	}

}