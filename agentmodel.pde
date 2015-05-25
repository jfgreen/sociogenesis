import java.util.Collection;
import java.util.ArrayList;

class AgentModel {

  Collection<Agent> agents;
  Collection<Pellet> pellets;

  AgentModel(int agentCount) {
    agents = new ArrayList();
    for(int i = 0; i < agentCount; i++) {
      PVector initalPositon = new PVector(random(width), random(height));
      float initalDirection = random(0, TWO_PI);
      agents.add(new Agent(initalPositon, initalDirection));
    }

    pellets = new ArrayList();
    for(int i = 0; i < 25; i++) {
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