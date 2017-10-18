if Meteor.isServer

	Meteor.publish 'coll', (name, selector) ->
		coll[name].find selector

	Meteor.methods
		upsert: (name, doc) -> coll[name].upsert _id: doc._id, doc
		remove: (name, doc) -> coll[name].remove doc._id
