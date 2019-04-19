import base64
import sys
import subprocess

def copy_to_clipboard(txt):
    cmd = "echo '%s' | pbcopy" % txt
    subprocess.check_call(cmd, shell=True)

if len(sys.argv) > 2:
    if sys.argv[1] == "e":
        result = base64.b64encode(sys.argv[2])
        print(result)
        copy_to_clipboard(result)
    elif sys.argv[1] == "d":
        result = base64.b64decode(sys.argv[2])
        print(result)
        copy_to_clipboard(result)
    else:
        print("Incorrect action - First argument should be either e for encode, d for decode or h for help")
elif len(sys.argv) > 1 and sys.argv[1] == "h":
    print("USE: python base64helper.py e|d '<string to encode/decode>. To decode, use d, to encode use e")
    print("EG: python base64helper.py e 'someString'")
    print("EG: python base64helper.py d 'c29tZVN0cmluZw=='")
else:
    print("Not enough arguments supplied")

