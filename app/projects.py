import requests

from json import loads

def getProjects():
    return requests.get("https://api.github.com/users/weskerfoot/repos?sort=updated&direction=desc&affiliation=owner").content
