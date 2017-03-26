Datastore = require('nedb')
config = require('./../config/config')

db={}
dbPath = config.dbFilePath
#创建users表,并定义users表的数据保存位置
db.users = new Datastore(dbPath+"users.db")
db.users.loadDatabase();
#创建task表
db.tasks = new Datastore(dbPath+"tasks.db")
db.tasks.loadDatabase();
module.exports=db;