if Meteor.isClient

	fill = (arr, val) -> _.assign _id: '', _.fromPairs _.zip arr, _.fill Array(_.size arr), val

	store = new ReactiveDict()
	store.set 'formVal', fill schema.pasien, ''

	comp.layout =
		view: -> m 'main', [comp.menu, comp.gabung]

	comp.menu =
		view: ->
			m '.navbar-fixed', m 'nav.teal', m '.nav-wrapper', [
				m 'ul.left', style: 'padding-left': '240px'
				, m 'li', m 'a', 'Home'
				m 'a.brand-logo.center', 'RSPB'
				m 'ul.right', m 'li', m 'a', 'Login'
				m 'ul.fixed.side-nav', [
					m 'li.grey.lighten-2', m 'a', m 'b', 'Admin Menu'
					_.map modules, (i) -> m 'li', [
						m 'span', m 'a', i.full
						m 'i.material-icons.right.teal-text', i.icon
					]
				]
			]

	form = (name) ->
		controller: reactive ->
			this.formEvent =
				onsubmit: (event) ->
					doc = {}
					event.preventDefault()
					_.map schema[name], (i) ->
						doc[i] = event.target.children[i].value
					id = store.get('formVal')._id
					if id then doc._id = id
					Meteor.call 'upsert', name, doc
					store.set 'formVal', fill schema[name], ''
				onkeypress: (event) -> console.log event, this
		view: (ctrl) ->
			m 'form', ctrl.formEvent, [
				_.map schema[name], (i) -> m 'input', name: i, value: store.get('formVal')[i]
				m 'input.btn', type: 'submit'
			]

	table = (name) ->
		sub: Meteor.subscribe 'coll', name, {}
		controller: reactive ->
			this.datas = coll[name].find().fetch()
			this.rowEvent = (doc) ->
				onclick: ->
					store.set 'formVal', doc
				ondblclick: ->
					Meteor.call 'remove', name, doc
		view: (ctrl) ->
			m 'table', [
				m 'thead', m 'tr', _.map schema[name], (i) ->
					m 'th', _.startCase i
				m 'tbody', _.map ctrl.datas, (i) ->
					m 'tr', ctrl.rowEvent(i), _.map schema[name], (j) ->
						m 'td', i[j]
			]
	
	comp.gabung =
		view: -> m '.container', [
			form 'pasien'
			table 'pasien'
		]

	m.mount document.body, comp.layout
