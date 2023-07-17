using StringDistances
using Downloads

hmtnamesurl = "https://raw.githubusercontent.com/homermultitext/hmt-authlists/master/data/hmtnames.cex"


f = Downloads.download(hmtnamesurl)
data = readlines(f)
rm(f)

idx = map(data[3:end]) do ln
    cols = split(ln, "|")
    (cols[1], cols[4])
end

apnamesdata = joinpath(pwd(), "named-entities", "apollodorus-nelist.txt") |> readlines

apnames = map(filter(ln -> ! isempty(ln), apnamesdata[2:end])) do ln
    split(ln, "|")[2]
end

apnames[2]

function scorename(s1, candidates, cutoff = 0.8)
    scores = map(candidates) do s2
        (s2, compare(s1, s2, Levenshtein()))
    end
    filter(pr -> pr[2] >= cutoff, scores)
end

score1 = scorename("Achilles", apnames)
score1[1]