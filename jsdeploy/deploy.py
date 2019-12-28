import os
import glob
from subprocess import Popen, PIPE
from mako.template import Template
from shutil import copyfile
import hashlib
import argparse

MAIN_RESOURCES = "../src/main/resources"
BUILD_RESOURCES = "../build/resources/main"

THYMELEAF_BUILD = "%s/templates" % BUILD_RESOURCES
THYMELEAF_MAIN = "%s/templates" % MAIN_RESOURCES

JS_BUILD = "%s/static/js" % BUILD_RESOURCES
JS_MAIN = "%s/static/js" % MAIN_RESOURCES 

TARGETS_THYMELEAF = [
    THYMELEAF_MAIN
]

TARGETS_JS = [
    JS_MAIN,
    JS_BUILD
]

PS_FILE_STEM = "ps-charts"
PS_FILE_NAME = "../purescript/dist/%s.js" % PS_FILE_STEM
PS_ID = "purescript"

ELM_FILE_STEM = "elm-charts"
ELM_FILE_NAME = "../elm/%s.js" % ELM_FILE_STEM
ELM_ID = "elm"


def write_thymeleaf(thymeleaf,fname):
    with open(fname,"w") as f:
        f.write(thymeleaf)

def read_md5_from_file():
    result = {}
    with open("deploy.md5") as f:
        lx = f.readlines()
        for line in lx:
            l = line.split(":") 
            key = l[0].strip()
            val = l[1].strip()
            result[key] = val
    return result

def write_md5_to_file(md5_dict):
    with open("deploy.md5", "w") as f:
        for k,v in md5_dict.items():
            f.write("%s:%s\n" % (k,v))



def ps_file_md5(digest):
    return "%s-%s.js" % (PS_FILE_STEM,digest)

def elm_file_md5(digest):
    return "%s-%s.js" % (ELM_FILE_STEM,digest)

def ps_build():
    process = Popen(["pbuild", "-s", "-f", "ps-charts"], stdout=PIPE, stderr=PIPE)
    #stdout, stderr = process.communicate()
    #print (stderr)
    return process.wait()

PURESCRIPT = 1

ELM = 2

def clean(args):
    for tp in TARGETS_JS:
        if args.p == True: 
            target_glob = "%s/maunaloa/%s*.js" % (tp,PS_FILE_STEM)
            fileList = glob.glob(target_glob, recursive=False)
            for filePath in fileList:
                try:
                    print ("Removing %s..." % filePath)
                    os.remove(filePath)
                except OSError:
                    print("Error while deleting file")
        if args.e == True: 
            target_glob = "%s/maunaloa/%s*.js" % (tp,ELM_FILE_STEM)
            fileList = glob.glob(target_glob, recursive=False)
            for filePath in fileList:
                try:
                    print ("Removing %s..." % filePath)
                    os.remove(filePath)
                except OSError:
                    print("Error while deleting file")

def generate_md5_from_src(fname):
    with open(fname) as ps_file:
        ps_content = ps_file.read()
        hx = hashlib.md5(ps_content.encode("utf-8")).hexdigest()
        hxt = hx[0:8]
        return hxt

def deploy(args):
    md5_dict = read_md5_from_file()
    if args.p == True:
        md5_dict[PS_ID] = generate_md5_from_src(PS_FILE_NAME)
    if args.e == True:
        md5_dict[ELM_ID] = generate_md5_from_src(ELM_FILE_NAME)

    print (md5_dict)

    write_md5_to_file(md5_dict)

    tpl = Template(filename="mako_templates/charts.html")

    thymeleaf = tpl.render(psver=md5_dict[PS_ID],elmver=md5_dict[ELM_ID])

    for tt in TARGETS_THYMELEAF:
        fname = "%s/maunaloa/charts.html" % tt
        print ("Installing %s..." % fname)
        write_thymeleaf(thymeleaf,fname)

    for tp in TARGETS_JS:
        if args.p == True:
            target_fname = "%s/maunaloa/%s" % (tp,ps_file_md5(md5_dict[PS_ID]))
            print ("Installing %s..." % target_fname)
            copyfile(PS_FILE_NAME,target_fname)
        if args.e == True:
            target_fname = "%s/maunaloa/%s" % (tp,elm_file_md5(md5_dict[ELM_ID]))
            print ("Installing %s..." % target_fname)
            copyfile(ELM_FILE_NAME,target_fname)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='A tutorial of argparse!')
    parser.add_argument("--p",action="store_true",help="Purecript")
    parser.add_argument("--e",action="store_true",help="Elm")
    args = parser.parse_args()
    clean(args)
    deploy(args)

    # clean(ELM+PURESCRIPT)
    # deploy()
    # print(generate_md5_from_src(ELM_FILE_NAME))