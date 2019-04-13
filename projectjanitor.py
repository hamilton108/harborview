#!/usr/bin/python3.6

from glob import glob
import os
import os.path
import shutil
import sys

RESOURCES = "src/main/resources"

OUT = "out/production/resources"

static_dirs = [
    ["static/css", "css"]
    ,["static/js", "js"]
    ,["static/js/maunaloa", "js"]
    ,["static/js/maunaloa/canvas", "js"]
    ,["static/js/maunaloa/svg", "js"]
    ]

template_dirs = [
    "templates"
    ,"templates/maunaloa" 
        ]


class FileLocation():
    def __init__(self,stem,file_ext): 
        self.stem = stem
        self.file_ext = file_ext
        self.sources = self.generate_sources()

    
    def generate_sources(self):
        cur_path = "%s/%s/*.%s" % (RESOURCES,self.stem,self.file_ext)
        return glob(cur_path)

   
    def copy_files(self):
        for f in self.sources:
            target_dir = "%s/%s" % (OUT,self.stem)
            target = "%s/%s" % (target_dir,os.path.basename(f))
            print (target)
            if not os.path.exists(target_dir):
                os.makedirs(target_dir)
            shutil.copyfile(f,target)

def copy_templates():
    for d in template_dirs:
        fl = FileLocation(d,"html")
        fl.copy_files()

def copy_static():
    for d in static_dirs:
        fl = FileLocation(d[0],d[1])
        fl.copy_files()

if __name__ == '__main__':
    if len(sys.argv) == 1:
        opt = '3'
    else:
        opt = sys.argv[1]
    if opt == '1':
        copy_templates()
    elif opt == '2':
        copy_static()
    else:
        copy_templates()
        copy_static()
        copy_static()

