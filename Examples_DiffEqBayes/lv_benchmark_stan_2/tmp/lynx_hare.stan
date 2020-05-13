functions {
    real[] dz_dt(real t,       // time
                 real[] z,     // system state {prey, predator}
                 real[] theta, // parameters
                 real[] x_r,   // unused data
                 int[] x_i) {
      real u = z[1];
      real v = z[2];

      real alpha = theta[1];
      real beta = theta[2];
      real gamma = theta[3];
      real delta = theta[4];

      real du_dt = (alpha - beta * v) * u;
      real dv_dt = (-gamma + delta * u) * v;

      return { du_dt, dv_dt };
    }
  }
  data {
    int<lower = 0> N;          // number of measurement times
    real ts[N];                // measurement times > 0
    real y_init[2];            // initial measured populations
    real<lower = 0> y[N, 2];   // measured populations
  }
  parameters {
    real<lower = 0> theta[4];   // { alpha, beta, gamma, delta }
    real<lower = 0> z_init[2];  // initial population
    real<lower = 0> sigma[2];   // measurement errors
  }
  transformed parameters {
    real z[N, 2]
      = integrate_ode_rk45(dz_dt, z_init, 0, ts, theta,
                           rep_array(0.0, 0), rep_array(0, 0),
                           1e-3, 1e-6, 1e5);
  }
  model {
    theta[1] ~ normal(1, 0.5) T[0.1, 3.0];
    theta[2] ~ normal(0.05, 0.1) T[0, 3];
    theta[3] ~ normal(1, 0.5) T[0.1, 4.0];
    theta[4] ~ normal(0.05, 0.1) T[0, 3];
    sigma ~ inv_gamma(2, 2);
    z_init ~ lognormal(10, 1);
    for (k in 1:2) {
      y_init[k] ~ lognormal(log(z_init[k]), sigma[k]);
      y[ , k] ~ lognormal(log(z[, k]), sigma[k]);
    }
  }
  generated quantities {
    real y_init_rep[2];
    real y_rep[N, 2];
    for (k in 1:2) {
      y_init_rep[k] = lognormal_rng(log(z_init[k]), sigma[k]);
      for (n in 1:N)
        y_rep[n, k] = lognormal_rng(log(z[n, k]), sigma[k]);
    }
  }