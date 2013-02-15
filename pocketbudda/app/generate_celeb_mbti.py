celebdict1 = {}
celeb = open("celebs")
for cline in celeb:
    ctoks = cline.replace("\n","").split("|")
    celebdict1[ctoks[0]] = ctoks[2]
celeb.close()

celebdict2 = {}
celeb = open("celeb_life_goal.txt")
for cline in celeb:
    ctoks = cline.replace("\n","").split(":")
    celebdict2[ctoks[0]] = ctoks[2]
celeb.close()

file = open("myer-briggs.txt")
out = open("mb-celeb-astro.txt","w")
for line in file:
    if line[0] == '#': continue
    tokens = line.split(":")
    tokens2 = tokens[1].split(" -")
    print "----------------------------------"
    if tokens2[0] in celebdict1 and tokens2[0] in celebdict2:
        print tokens2[0]
        print tokens[0]
        print "<" + celebdict1[tokens2[0]] + ">"
        print "<" + celebdict2[tokens2[0]] + ">"
        out.write(tokens[0] + "|" + tokens2[0] + "|" + celebdict2[tokens2[0]] + ":" + celebdict1[tokens2[0]])
        out.write("\n")
    
out.close()
file.close()
