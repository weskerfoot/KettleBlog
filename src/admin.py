#! /usr/bin/python3

class Admin:
    def __init__(self):
        return

    def is_authenticated(self):
        return True

    def is_active(self):
        return True

    def is_anonymous(self):
        return False

    def get_id(self):
        return "admin"
