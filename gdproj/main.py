
"""
MIT License

Copyright (c) 2016 William Tumeo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

# TODO: Start Godot using multi-process

import sys
import os
import subprocess
import yaml


GDFILE = '.gdpath'
GDPATH = None
GDVERSION = None


class NotAGodotProjectException(Exception):
    pass

class GodotPathException(Exception):
    pass


def is_gdproj(full_path):
    dirs = os.path.split(full_path)
    return '.gdproj' in dirs[-1]


def get_proj_path(full_path):
    dirs = os.path.split(full_path)
    proj_path = list(dirs)
    del proj_path[-1]
    return '"%s"' % proj_path


def get_gdversion(verfile):
    version = None
    with open(verfile, 'r', encoding='utf-8') as verf:
        for line in verf:
            version = line
            break
    if version is None:
        version = 'default'
    if version.strip() == '':
        version = 'default'
    return version


def get_gdexecutable(path, versions):
    vers = None
    with open(os.path.join(path, versions)) as gdfile:
        vers = yaml.load(gdfile.read())

    if vers is None:
        raise GodotPathException('Godot Path was not found')
    if not isinstance(vers, dict):
        raise GodotPathException('Godot Path was not found')
    return vers


if __name__ == '__main__':
    print('GDPROJ INIT')
    try:
        print('FILE:', sys.argv[1])
        if not is_gdproj(sys.argv[1]):
            raise NotAGodotProjectException(sys.argv[1]+' is not a Godot Project')

        GDVERSION = get_gdversion(sys.argv[1])
        print('GODOT_VERSION:', GDVERSION)
        
        GDPATH = get_gdexecutable(os.path.dirname(sys.argv[0]), GDFILE)
        print('PATH:', GDPATH[GDVERSION])

        if len(sys.argv) > 0:
            print(get_proj_path(sys.argv[1]))
            subprocess.Popen([GDPATH[GDVERSION], '-path', get_proj_path(sys.argv[1]), '-e'])
    
    except NotAGodotProjectException as gder:
        print(gder)
        print('NOT A GDPROJ!')
        input('ENTER TO EXIT')
    
    except GodotPathException as gdp:
        print(gdp)
        input('ENTER TO EXIT')

    except IndexError as ie:
        print(ie)
        print("Don't execute this program!")
        input('ENTER TO EXIT')
    
    except KeyError as ke:
        print('This version of Godot was not found!')
        input('ENTER TO EXIT')
