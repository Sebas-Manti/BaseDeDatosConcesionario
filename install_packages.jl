using Pkg
Pkg.activate(".")
Pkgs = ["HTTP","JSON3","MySQL","TOML","Dates","UUIDs"]
for p in Pkgs
    try
        println("ADDING ", p)
        Pkg.add(p)
    catch e
        println("ERROR adding ",p,": ",e)
    end
end
try
    Pkg.precompile()
catch e
    println("PRECOMPILE ERROR: ", e)
end
