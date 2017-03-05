from json import dumps

from random import randint

from time import time

def comment(author, title, text, t):
    return {
            "time" : t,
            "id" : randint(1,2**32-1),
            "title"  : title,
            "author" : author,
            "text"   : text
            }


testcomments = {
                1 : dumps(
                    [
                        comment("Person 1", "Two", "A Comment here", 1),
                        comment("Person 2", "One", "Some other comment", 2),
                        comment("Person 3", "Three", "My opinion is correct", 3)
                        ]),
                2 : dumps(
                    [
                        comment("Person 1", "Two", "A cool terrible Comment here", 1),
                        comment("Person 2", "One", "Some other awful comment", 2),
                        comment("Person 3", "Three", "My opinion is not correct", 3)
                    ])
                    }
