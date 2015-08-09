class Parameters {
  int agentCount = 30;
  int pelletCount = 100;
  float kPlace = 3; // Neighborhood size at which there is a 25% chance of placing. (Sizes above this will have a greater chance.)
  float kTake = 3; // Neighborhood size at which there is a 25% change of taking. (Sizes abover this will have a lower chance.)
  float neighbourThreshold = 25; // The radius around a pellet that is considered within its
  int iterationsPerFrame = 1;
}