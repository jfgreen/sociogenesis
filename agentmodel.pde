import java.util.Collection;
import java.util.ArrayList;

class AgentModel {

  Collection<Agent> agents;
  Collection<Pellet> pellets;

  AgentModel(int agentCount, int pelletCount) {
    agents = new ArrayList();
    for(int i = 0; i < agentCount; i++) {
      PVector initalPositon = new PVector(random(width), random(height));
      float initalDirection = random(0, TWO_PI);
      Brain brain = new Brain();
      agents.add(new Agent(initalPositon, initalDirection, brain));
    }

    pellets = new ArrayList();
    for(int i = 0; i < pelletCount; i++) {
      PVector initalPositon = new PVector(random(width), random(height));
      pellets.add(new Pellet(initalPositon));
    }
  }

  void update() {
    for(Agent agent : agents) {
      agent.update(pellets);
    }
  }

  void draw() {
    for(Agent agent : agents) {
      agent.draw();
    }
    for(Pellet pellet : pellets) {
      pellet.draw();
    }
  }
}