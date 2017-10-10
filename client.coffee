if Meteor.isClient

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
		formValue: new ReactiveVar _id: '', nama: '', alamat: ''
		formEvent: ->
			onsubmit: (event) ->
				event.preventDefault()
				data = {}
				for i in schema.pasien
					data[i] = event.target.children[i].value
				Meteor.call 'upsert', 'pasien', data
		view: -> m '.container', style: 'padding-left': '240px', [
			m 'form', this.formEvent(), [
				m 'h5', 'Pendaftaran Pasien'
				_.map schema.pasien, (i) -> m 'input',
					name: i
					placeholder: _.capitalize i
					value: comp.modul.formValue.curValue[i]
				m 'input.btn', type: 'submit'
			]
		]

	m.mount document.body, comp.layout
