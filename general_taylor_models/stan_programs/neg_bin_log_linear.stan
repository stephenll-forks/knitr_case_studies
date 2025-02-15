data {
  int<lower=0> M; // Number of covariates
  int<lower=0> N; // Number of observations
  
  vector[M] x0;   // Covariate baselines
  matrix[N, M] X; // Covariate design matrix
  
  int y[N];      // Variates
}

transformed data {
  matrix[N, M] deltaX;
  for (n in 1:N) {
    deltaX[n,] = X[n] - x0';
  }
}

parameters {
  real alpha;            // Intercept
  vector[M] beta;        // Slopes
  real<lower=0> inv_phi; // Dispersion parameter
}

transformed parameters {
  // inv_phi = 0, phi = +infty reduces to initial Poisson model
  real<lower=0> phi = 1 / inv_phi;
}

model {
  // Prior model
  alpha ~ normal(3, 0.2);
  beta ~ normal(0, log(1.28));
  inv_phi ~ normal(0, 1); // Expand around initial Poisson model

  // Vectorized observation model
  y ~ neg_binomial_2_log(alpha + deltaX * beta, phi);
}

// Simulate a full observation from the current value of the parameters
generated quantities {
  vector[N] mu = exp(alpha + deltaX * beta);
  int y_pred[N] = neg_binomial_2_log_rng(alpha + deltaX * beta, phi);
}
