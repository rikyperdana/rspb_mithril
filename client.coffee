if Meteor.isClient

	empty = (arr) -> _.assign _id: '', _.fromPairs _.zip arr, _.fill Array(_.size arr), ''

	comp.layout =
		view: -> m 'main', [comp.menu, comp.modul]

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

	comp.modul =
		sub: Meteor.subscribe 'coll', 'pasien', {}
		formValue: new ReactiveVar empty schema.pasien
		datas: reactive -> this.res = coll.pasien.find().fetch()
		formEvent: ->
			onsubmit: (event) ->
				event.preventDefault()
				data = {}
				for i in schema.pasien
					data[i] = event.target.children[i].value
				_id = comp.modul.formValue.curValue._id
				data._id = if _id then _id
				Meteor.call 'upsert', 'pasien', data
				comp.modul.formValue.set empty schema.pasien
		tableEvent: (doc) ->
			onclick: ->
				comp.modul.formValue.set doc
		view: -> m '.container', style: 'padding-left': '240px', [
			m 'form', this.formEvent(), [
				m 'h5', 'Pendaftaran Pasien'
				_.map schema.pasien, (i) -> m 'input',
					name: i
					placeholder: _.capitalize i
					value: comp.modul.formValue.curValue[i]
				m 'input.btn', type: 'submit'
			]
			m 'table', [
				m 'thead', m 'tr', _.map schema.pasien, (i) ->
					m 'th', _.capitalize i
				m 'tbody', _.map comp.modul.datas().res, (i) ->
					m 'tr', comp.modul.tableEvent(i), _.map schema.pasien, (j) ->
						m 'td', i[j]
			]
		]

	m.mount document.body, comp.layout
