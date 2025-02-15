data {
  int<lower=0> M; // Number of covariates
  int<lower=0> N; // Number of observations
  
  vector[M] x0;   // Covariate baselines
  matrix[N, M] X; // Covariate design matrix
}

transformed data {
  matrix[N, M] deltaX;
  for (n in 1:N) {
    deltaX[n,] = X[n] - x0';
  }
}

parameters {
  real alpha;          // Intercept
  vector[M] beta;      // Slopes
  real<lower=0> sigma; // Measurement Variability
}

model {
  // Prior model
  alpha ~ normal(0, 10);
  beta ~ normal(0, 10);
  sigma ~ normal(0, 5);
}

// Simulate a full observation from the current value of the parameters
generated quantities {
  vector[N] mu = alpha + deltaX * beta;
}
