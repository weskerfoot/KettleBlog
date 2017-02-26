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
                        comment("Anonymous Coward 0", "Some comment?", "super duper awesome comment here"),
                        comment("Anonymous Coward 1", "Something? IDEK", "super duper worse comment here"),
                        comment("Anonymous Coward 2", "Some other comment?", "super duper dang terrible comment here")
                        ]),
                2 : dumps(
                    [
                        comment("Anonymous Coward 3", "Some comment?", "super duper awesome comment here"),
                        comment("Anonymous Coward 4", "Something? IDEK", "super duper worse comment here"),
                        comment("Anonymous Coward 5", "Some other comment?", "super duper dang terrible comment here")
                        ])
                    }
