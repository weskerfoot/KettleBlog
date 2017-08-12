import requests

from json import loads

def getProjects():
    return requests.get("https://api.github.com/users/nisstyre56/repos?sort=updated&direction=desc&affiliation=owner").content
