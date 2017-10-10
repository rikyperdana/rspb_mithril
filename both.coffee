@_ = lodash
@comp = {}
@coll = {}
coll.pasien = new Mongo.Collection 'pasien'
@schema = {}
schema.pasien = ['nama', 'alamat']
