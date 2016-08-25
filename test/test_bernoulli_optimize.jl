ProjDir = joinpath(dirname(@__FILE__), "..", "Examples", "Bernoulli")
cd(ProjDir) do

  isdir("tmp") &&
    rm("tmp", recursive=true);

  include(joinpath(ProjDir, "bernoulli_optimize.jl"))

  isdir("tmp") &&
    rm("tmp", recursive=true);

end # cd
