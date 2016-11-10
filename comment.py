from json import dumps

def comment(author, title, text):
    return {
            "title"  : title,
            "author" : author,
            "text"   : text
            }


testcomments = {
                1 : dumps(
                            [
                                comment("Anonymous Coward", "Some comment?", "super duper awesome comment here"),
                                comment("Anonymous Coward 3", "Something? IDEK", "super duper worse comment here"),
                                comment("Anonymous Coward 2", "Some other comment?", "super duper dang terrible comment here")
                            ])
                }
