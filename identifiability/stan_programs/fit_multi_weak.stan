data {
  int<lower=1> N;      // Number of observations
  real y[N];           // Observations
  real<lower=0> sigma; // Measurement variability
}

parameters {
  real<lower=0> a;
  real b;
}

model {
  // Prior model
  a ~ normal(0, 100);
  b ~ normal(0, 100);
  
  // Observational model
  y ~ normal(a * b, sigma);
}
