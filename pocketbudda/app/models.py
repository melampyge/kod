from google.appengine.ext import db

class AppUser(db.Model):
    bday = db.IntegerProperty(required=True)
    spiller = db.StringProperty(required=True)
    chinese = db.StringProperty(required=True)
    btype = db.StringProperty(required=True, choices=set(["A", "B", "AB", "O"]))
    lewi = db.ListProperty(long, required=True)
    nick = db.StringProperty(required=True)

class Post(db.Model):
    message = db.StringProperty(required=True)
    #user = db.ReferenceProperty(AppUser, required=True)
    date = db.DateTimeProperty(auto_now_add=True)
    
