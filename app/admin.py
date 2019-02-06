#! /usr/bin/python3

class Admin:
    def __init__(self):
        return

    # admin user is always authenticated for everything so it's a constant
    def is_authenticated(self):
        return True

    def is_active(self):
        return True

    # we don't have anonymous users on this site
    def is_anonymous(self):
        return False

    def get_id(self):
        return "admin"
