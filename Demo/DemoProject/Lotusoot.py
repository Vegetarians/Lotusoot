import plistlib
import re
import os, sys

scanPath = sys.argv[1]
lotusootFiles = []

print 'scan path is : ' + scanPath

def removeSuffix(file):
    return file.replace('.swift', '')

def getNameSpace(line):
    nameSpaceSearch = re.search(r'@NameSpace\((.*?)\)', line, re.M | re.I)
    if nameSpaceSearch:
        return nameSpaceSearch.group(1)
    else:
        return ''

def getLotusoot(line):
    lotusooteSearch = re.search(r'@Lotusoot\((.*?)\)', line, re.M | re.I)
    if lotusooteSearch:
        return lotusooteSearch.group(1)
    else:
        return ''

def getLotus(line):
    lotusSearch = re.search(r'@Lotus\((.*?)\)', line, re.M | re.I)
    if lotusSearch:
        return lotusSearch.group(1)
    else:
        return ''

def findLotusoots(path, suffix):
    list = []
    for root, subFolders, files in os.walk(path):
        # Ignore 'Target Support Files' and 'Pods.xcodeproj'
        if 'Target Support Files' in subFolders:
            subFolders.remove('Target Support Files')
        if 'Pods.xcodeproj' in subFolders:
            subFolders.remove('Pods.xcodeproj')
        for f in files:
            if f.endswith(suffix):
                list.append(os.path.join(root, f))
    return list

def findAmbiguityLotusoots(path):
    list = []
    for root, subFolders, files in os.walk(path):
        # Ignore 'Target Support Files' and 'Pods.xcodeproj'
        if 'Target Support Files' in subFolders:
            subFolders.remove('Target Support Files')
        if 'Pods.xcodeproj' in subFolders:
            subFolders.remove('Pods.xcodeproj')
        for f in files:
            if f.endswith('.swift'):
                tup = getLotusootConfig(os.path.join(root, f))
                if tup[0] and tup[1] and tup[2]:
                    list.append(f)
    return list

def getLotusootConfig(file):
    lotus = ''
    lotusoot = ''
    namespace = ''
    for line in open(file):
        if getLotus(line):
            lotus = getLotus(line)
        if getLotusoot(line):
            lotusoot = getLotusoot(line)
        if getNameSpace(line):
            namespace = getNameSpace(line)
    return (lotus, lotusoot, namespace)

# config Suffix
lotusootSuffix = 'Lotusoot'
length = len(sys.argv)
if length != 3 and length != 4:
    print 'parameter error'
    os._exit(1)
if length == 4:
    lotusootSuffix = sys.argv[3]
    lotusootFiles = findLotusoots(scanPath, lotusootSuffix + '.swift')
else:
    lotusootFiles = findAmbiguityLotusoots(scanPath)

print 'Your lotusoot suffix is ' + lotusootSuffix

# analyze lotusoot file
lotusMap = {}
for file in lotusootFiles:
    tup =  getLotusootConfig(file)
    lotus = tup[0]
    lotusoot = tup[1]
    namespace = tup[2]
    for line in open(file):
        if getLotus(line):
            lotus = getLotus(line)
        if getLotusoot(line):
            lotusoot = getLotusoot(line)
        if getNameSpace(line):
            namespace = getNameSpace(line)
    if not lotus:
        print 'you lose @NameSpace(Lotus protocol name) in ' + file
        os._exit(1)
    if not lotusoot:
        print 'you lose @Lotusoot(Lotusoot class name) in ' + file
        os._exit(1)
    if not namespace:
        print 'you lose @NameSpace(module namespace) in ' + file
        os._exit(1)

    lotusMap[lotus] = namespace + '.' + lotusoot

print 'Your lotus map is : ' + str(lotusMap)
plistlib.writePlist(lotusMap, "Lotusoot.plist")
print 'drag the Lotusoot.plist files into your project and uncheck Copy items if needed'