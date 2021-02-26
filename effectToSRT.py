import sys
import json
import srt


if __name__ == "__main__":
    if (len(sys.argv) != 4):
        print("invalid number of args. quitting...")
        quit()
    infile_srt = sys.argv[1]
    append_before = sys.argv[2]
    append_after = sys.argv[3]
    in_string = ""
    with open(infile_srt) as infile:
        in_string = infile.read()
    subs = list(srt.parse(in_string))
    for sub in subs:
        print(sub.content)
        sub.content = append_before + sub.content + append_after
    print(srt.compose(subs))
    