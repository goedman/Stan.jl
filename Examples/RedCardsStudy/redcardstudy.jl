Pkg.instantiate()

using Distributed, StanSample, CSV, DataFrames
Pkg.instantiate()

ProjDir = @__DIR__
cd(ProjDir)

rcd = CSV.read(joinpath(ProjDir, "RedCardData.csv"), DataFrame; missingstring = "NA")
rcd = dropmissing(rcd, :rater1)
rcd[!, :rater1] = Float64.(rcd.rater1)

stan_logistic_0 ="
data {
  int<lower=0> N;
  int<lower=0> n_redcards[N];
  int<lower=0> n_games[N];
  vector[N] rating;
}
parameters {
  vector[2] beta;
}
model {
  beta[1] ~ normal(0, 10);
  beta[2] ~ normal(0, 1);
  n_redcards ~ binomial_logit(n_games, beta[1] + beta[2] * rating);
}
";

stan_logistic_1 = "
functions {
  real partial_sum_lpmf(int[] slice_n_redcards,
                        int start, int end,
                        int[] n_games,
                        vector rating,
                        vector beta) {
    return binomial_logit_lupmf(slice_n_redcards |
                               n_games[start:end],
                               beta[1] + beta[2] * rating[start:end]);
  }
}
data {
  int<lower=0> N;
  int<lower=0> n_redcards[N];
  int<lower=0> n_games[N];
  vector[N] rating;
  int<lower=1> grainsize;
}
parameters {
  vector[2] beta;
}
model {

  beta[1] ~ normal(0, 10);
  beta[2] ~ normal(0, 1);
  target += reduce_sum(partial_sum_lupmf, n_redcards, grainsize,
                       n_games, rating, beta);
}
";

#isdir("tmp0") && rm("tmp0", recursive=true);
if !isdir("tmp0")
  tmp0 = mkdir(joinpath(ProjDir, "tmp0"))
else
  tmp0 = joinpath(ProjDir, "tmp0")
end;

logistic_0 = SampleModel("logistic0", stan_logistic_0, [1]; tmpdir=tmp0)

#isdir("tmp1") && rm("tmp1", recursive=true);
if !isdir("tmp1")
  tmp1 = mkdir(joinpath(ProjDir, "tmp1"))
else
  tmp1 = joinpath(ProjDir, "tmp1")
end;

logistic_1 = SampleModel("logistic1", stan_logistic_1; tmpdir=tmp1)

data = Dict(
    :N => size(rcd, 1),
    :grainsize => 1,
    :n_redcards => rcd.redCards,
    :n_games => rcd.games,
    :rating => rcd.rater1
)

for i in 1:1
  #addprocs(1)
  println("\nUsing $(nprocs()) cores.\n")
  @time rc_0 = stan_sample(logistic_0; data);

  if success(rc_0)
      dfs_0 = read_summary(logistic_0)
      dfs_0[8:9, [1,2,4,8,9,10]] |> display
      println()
  end

  @time rc_1 = stan_sample(logistic_1; data);

  if success(rc_1)
      dfs_1 = read_summary(logistic_1)
      dfs_1[8:9, [1,2,4,8,9,10]] |> display
      println()
  end
end
