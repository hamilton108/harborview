import os
import glob
from subprocess import Popen, PIPE
from mako.template import Template
from shutil import copyfile
import hashlib

MAIN_RESOURCES = "../src/main/resources"
BUILD_RESOURCES = "../build/resources/main"

THYMELEAF_BUILD = "%s/templates" % BUILD_RESOURCES
THYMELEAF_MAIN = "%s/templates" % MAIN_RESOURCES

PS_BUILD = "%s/static/js" % BUILD_RESOURCES
PS_MAIN = "%s/static/js" % MAIN_RESOURCES 

TARGETS_THYMELEAF = [
    THYMELEAF_MAIN
]

TARGETS_PURESCRIPT = [
    PS_MAIN 
    , PS_BUILD
]

PS_FILE_STEM = "ps-charts"

PS_FILE_NAME = "dist/%s.js" % PS_FILE_STEM

def write_thymeleaf(thymeleaf,fname):
    with open(fname,"w") as f:
        f.write(thymeleaf)

def ps_file_md5(digest):
    return "%s-%s.js" % (PS_FILE_STEM,digest)

def ps_build():
    process = Popen(["pbuild", "-s", "-f", "ps-charts"], stdout=PIPE, stderr=PIPE)
    #stdout, stderr = process.communicate()
    #print (stderr)
    return process.wait()

def clean():
    for tp in TARGETS_PURESCRIPT:
        target_glob = "%s/maunaloa/%s*.js" % (tp,PS_FILE_STEM)
        fileList = glob.glob(target_glob, recursive=False)
        
        # Iterate over the list of filepaths & remove each file.
        for filePath in fileList:
            try:
                print ("Removing %s..." % filePath)
                os.remove(filePath)
            except OSError:
                print("Error while deleting file")

def deploy():
    with open(PS_FILE_NAME) as ps_file:
        ps_content = ps_file.read()

        hx = hashlib.md5(ps_content.encode("utf-8")).hexdigest()

        hxt = hx[0:8]

        tpl = Template(filename="mako_templates/charts.html")

        thymeleaf = tpl.render(psver=hxt)

        for tt in TARGETS_THYMELEAF:
            fname = "%s/maunaloa/charts.html" % tt
            print ("Installing %s..." % fname)
            write_thymeleaf(thymeleaf,fname)

        psmd5 = ps_file_md5(hxt)

        for tp in TARGETS_PURESCRIPT:
            target_fname = "%s/maunaloa/%s" % (tp,psmd5)
            print ("Installing %s..." % target_fname)
            copyfile(PS_FILE_NAME,target_fname)

if __name__ == "__main__":
    clean()
    deploy()



