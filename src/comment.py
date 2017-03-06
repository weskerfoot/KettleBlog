from json import dumps
from time import time
from uuid import uuid4

def comment(author, title, text, t, uid):
    return {
            "time" : t,
            "id" : uid,
            "title"  : title,
            "author" : author,
            "text"   : text
            }


testcomments = {
                1 : dumps(
                    [
                        comment("Person 1", "Two", "A Comment here", 1, str(uuid4())),
                        comment("Person 2", "One", "Some other comment", 2, str(uuid4())),
                        comment("Person 3", "Three", "My opinion is correct", 3, str(uuid4()))
                        ]),
                2 : dumps(
                    [
                        comment("Person 1", "Two", "A cool terrible Comment here", 1, str(uuid4())),
                        comment("Person 2", "One", "Some other awful comment", 2, str(uuid4())),
                        comment("Person 3", "Three", "My opinion is not correct", 3, str(uuid4()))
                    ])
                    }
