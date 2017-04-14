
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


GDFILE = 'gdpath.yml'


class NotAGodotProjectException(Exception):
    pass

class GodotPathException(Exception):
    pass


def is_gdproj(full_path):
    return os.path.splitext(full_path)[-1] == '.gdproj'

def get_proj_path(full_path):
    path = os.path.dirname(os.path.abspath(full_path))
    print('PROJ PATH:', path)
    return path

def get_gdversion(verfile):
    version = None
    with open(verfile, 'r', encoding='utf-8') as verf:
        for line in verf:
            version = line
            break
    if version is None:
        return 'default'
    if version.strip() == '':
        return 'default'
    return version.strip()

def has_executables(configs):
    if not 'versions' in configs:
        raise GodotPathException('Godot Path was not found')
    if not isinstance(configs, dict):
        raise GodotPathException('Godot Path was not found')
    return True

def get_configs(path):
    with open(path, 'r', encoding='utf-8') as gdfile:
        return yaml.load(gdfile.read())

def parse_configs(configs):
    if has_executables(configs):
        gd_version = get_gdversion(sys.argv[1])
        print('GODOT VERSION:', gd_version)
        return (
            configs['versions'][gd_version],
            get_proj_path(sys.argv[1]),
            configs.get('console', True),
            configs.get('callers')
        )

def start_godot(exe, path, console=True, callers=None):
    args = [exe, '-path', path, '-e']
    if callers is not None:
        args = callers + args
    if console:
        args = ['cmd', '/c', 'start'] + args

    print('COMMANDLINE:', *args)
    subprocess.call(args)

if __name__ == '__main__':
    print('GDPROJ INIT')
    try:
        print('FILE:', sys.argv[1])
        if not is_gdproj(sys.argv[1]):
            raise NotAGodotProjectException(sys.argv[1]+' is not a Godot Project')

        CONFIGS = get_configs(os.path.join(os.path.dirname(sys.argv[0]), GDFILE))
        start_godot(*parse_configs(CONFIGS))

    except NotAGodotProjectException as gderr:
        print(gderr)
        print('NOT A GDPROJ!')
        input('ENTER TO EXIT')

    except GodotPathException as gdp:
        input('ENTER TO EXIT')

    except IndexError:
        print("Don't execute this program!")
        input('ENTER TO EXIT')

    except KeyError:
        print('This version of Godot was not found!')
        input('ENTER TO EXIT')

    except FileNotFoundError as ferr:
        print(ferr)
        input('ENTER TO EXIT')
