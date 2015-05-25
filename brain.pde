import java.util.Collection;
import java.util.ArrayList;

class Brain {

  float NEIGHBOURHOOD = 25;
  float kP = 2; // Tunes the probability of placing. Lower is more likely.
  float kT = 2; // Tunes the probability of taking. Higher is more likely.

  Brain() {

  }

  boolean shouldPlace(Pellet pellet, Collection<Pellet> allPellets) {
    float f = float(getNeighbourhood(pellet, allPellets, NEIGHBOURHOOD).size());
    float probability = pow(f/(f+kP), 2);
    return random(0, 1) < probability;
  }

  boolean shouldTake(Pellet pellet, Collection<Pellet> allPellets) {
    float f = float(getNeighbourhood(pellet, allPellets, NEIGHBOURHOOD).size());
    float probability = pow(kT/(f+kT), 2);
    return random(0, 1) < probability;
  }

  Collection<Pellet> getNeighbourhood(Pellet pellet, Collection<Pellet> allPellets, float threshold) {
    ArrayList<Pellet> neighbours = new ArrayList();
    for (Pellet otherPellet : allPellets) {
      if (pellet.position.dist(otherPellet.position) < threshold && otherPellet != pellet) {
        neighbours.add(otherPellet);
      }
    }
    return neighbours;
  }

}